// const menuLinks = document.querySelectorAll('.menu-link');

// menuLinks.forEach(link => {
//   link.addEventListener('click', function(e) {
//     e.preventDefault(); // Prevent default link behavior
//     const href = this.getAttribute('href');
//     window.location.href = href; // Redirect to the linked path
//   });
// });



import 'ol/ol.css';
import { Map, View } from 'ol';
import { createBaseLayer } from './layers.js';

// Create a new map
const map = new Map({
    target: 'map',
    layers: [
        createBaseLayer()  // Use the function from layers.js to create the base layer
    ],
    view: new View({
        center: [0, 0],
        zoom: 2
    })
});

// Export the map object if you need to use it in other modules
export default map;
