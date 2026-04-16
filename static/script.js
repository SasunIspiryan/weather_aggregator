// Weather Aggregator JavaScript with enhanced functionality

let allWeatherData = [];
let filteredData = [];

// Weather condition to icon mapping
const weatherIcons = {
    'clear': 'fas fa-sun',
    'sunny': 'fas fa-sun',
    'partly cloudy': 'fas fa-cloud-sun',
    'cloudy': 'fas fa-cloud',
    'overcast': 'fas fa-cloud',
    'rain': 'fas fa-cloud-rain',
    'light rain': 'fas fa-cloud-rain',
    'heavy rain': 'fas fa-cloud-showers-heavy',
    'snow': 'fas fa-snowflake',
    'thunderstorm': 'fas fa-bolt',
    'fog': 'fas fa-smog',
    'mist': 'fas fa-smog'
};

// Function to get weather icon class
function getWeatherIcon(condition) {
    const key = condition.toLowerCase();
    return weatherIcons[key] || 'fas fa-cloud';
}

function formatMetric(value, suffix, digits = 1) {
    if (value === null || value === undefined || Number.isNaN(Number(value))) {
        return `N/A${suffix}`;
    }

    return `${Number(value).toFixed(digits)}${suffix}`;
}

const API_URL = '/api/v1/all-weather';

// Function that loads weather data from backend API
async function loadWeather() {
    const loading = document.getElementById('loading');
    const error = document.getElementById('error');
    const container = document.getElementById('weather-container');

    // Show loading state
    loading.style.display = 'block';
    error.style.display = 'none';
    container.innerHTML = '';

    try {
        // Send request to Flask API endpoint
        const response = await fetch(API_URL, { cache: 'no-store' });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        // Convert response into JSON format
        const data = await response.json();

        // Store data globally
        allWeatherData = data;
        filteredData = [...data];

        // Process returned weather data
        displayWeatherData(filteredData);

        // Hide loading state
        loading.style.display = 'none';

    } catch (err) {
        console.error('Error loading weather data:', err);
        loading.style.display = 'none';
        error.style.display = 'block';
        document.getElementById('error-message').textContent =
            `Failed to load weather data. Please try again later. (${err.message})`;
    }
}

// Function to display weather data
function displayWeatherData(data) {
    const container = document.getElementById('weather-container');
    container.innerHTML = '';

    // Loop through each city returned from the API
    data.forEach((city, index) => {
        // Create new HTML div element
        const card = document.createElement("div");
        card.className = "card";
        card.style.animationDelay = `${index * 0.1}s`;

        // Get weather icon
        const conditionText = city.condition || 'Unavailable';
        const iconClass = getWeatherIcon(conditionText);
        const errorMarkup = city.error
            ? `<div class="condition">${city.error}</div>`
            : `<div class="condition">${conditionText}</div>`;

        // Insert enhanced weather information into the card
        card.innerHTML = `
            <div class="city">
                <i class="${iconClass} weather-icon"></i>
                ${city.city}
            </div>
            <div class="temp">
                ${city.temperature ?? 'N/A'}°C
                <i class="fas fa-thermometer-half" style="font-size: 1.5rem; color: #ff6b6b;"></i>
            </div>
            ${errorMarkup}
            <div class="weather-details">
                <div class="detail-item">
                    <i class="fas fa-wind"></i>
                    <span>${formatMetric(city.wind_speed, ' km/h')}</span>
                </div>
                <div class="detail-item">
                    <i class="fas fa-tint"></i>
                    <span>${formatMetric(city.humidity, '%')}</span>
                </div>
                <div class="detail-item">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>${formatMetric(city.pressure, ' hPa')}</span>
                </div>
                <div class="detail-item">
                    <i class="fas fa-eye"></i>
                    <span>${formatMetric(city.visibility, ' km')}</span>
                </div>
            </div>
        `;

        // Add click event for card expansion (optional enhancement)
        card.addEventListener('click', () => {
            card.classList.toggle('expanded');
        });

        // Add card to the container on the webpage
        container.appendChild(card);
    });
}

// Search functionality
function setupSearch() {
    const searchInput = document.getElementById('search-input');
    const searchBtn = document.getElementById('search-btn');

    function performSearch() {
        const query = searchInput.value.toLowerCase().trim();
        if (query === '') {
            filteredData = [...allWeatherData];
        } else {
            filteredData = allWeatherData.filter(city =>
                city.city.toLowerCase().includes(query)
            );
        }
        displayWeatherData(filteredData);
    }

    searchInput.addEventListener('input', performSearch);
    searchBtn.addEventListener('click', performSearch);

    // Allow Enter key to trigger search
    searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            performSearch();
        }
    });
}

// Refresh button functionality
function setupRefresh() {
    const refreshBtn = document.getElementById('refresh-btn');
    const icon = refreshBtn.querySelector('i');

    refreshBtn.addEventListener('click', () => {
        // Add spinning animation
        icon.style.animation = 'spin 1s linear';
        loadWeather();

        // Remove animation after spinning
        setTimeout(() => {
            icon.style.animation = '';
        }, 1000);
    });
}

// Add CSS animation for spinning
const style = document.createElement('style');
style.textContent = `
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
`;
document.head.appendChild(style);

// Initialize the application
function init() {
    setupSearch();
    setupRefresh();
    loadWeather();

    // Refresh weather data automatically every 5 minutes (300000 ms)
    setInterval(loadWeather, 300000);
}

// Run initialization when page loads
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}