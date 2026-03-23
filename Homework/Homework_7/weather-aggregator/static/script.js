// function that loads weather data from backend API
function loadWeather(){

// send request to Flask API endpoint
fetch("/api/v1/all-weather")

// convert response into JSON format
.then(response => response.json())

// process returned weather data
.then(data => {

    // get container element from HTML page
    let container = document.getElementById("weather-container");

    // clear previous weather cards before updating
    container.innerHTML = "";

    // loop through each city returned from the API
    data.forEach(city => {

        // create new HTML div element
        let card = document.createElement("div");

        // assign CSS class for styling
        card.className = "card";

        // insert weather information into the card
        card.innerHTML = `
        <div class="city">${city.city}</div>
        <div class="temp">${city.temperature}°C</div>
        <div class="condition">${city.condition}</div>
        <div>Wind: ${city.wind_speed} km/h</div>
        `;

        // add card to the container on the webpage
        container.appendChild(card);

    });

});

}

// run function immediately when page loads
loadWeather();

// refresh weather data automatically every 10 seconds
setInterval(loadWeather,10000);