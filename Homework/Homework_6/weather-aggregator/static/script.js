// Function to call backend weather API
function getWeather(){

    // Fetch data from Flask backend
    fetch('/weather')

    // Convert response to JSON
    .then(response => response.json())

    // Process returned data
    .then(data => {

        // Display weather data on the page
        document.getElementById("weather").innerHTML =
        "City: " + data.city +
        "<br>Temperature: " + data.temperature +
        "<br>Wind Speed: " + data.windspeed +
        "<br>Condition: " + data.condition;
    })

}
