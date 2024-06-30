import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import Stamen from 'ol/source/Stamen';

export function createBaseLayer() {
    return new TileLayer({
        source: new OSM()
    });
}

// Add other layers if needed
export const osmHumanitarianLayer = new TileLayer({
    source: new OSM({
        url: 'https://{a-c}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
    }),
    visible: false
});

export const stamenTerrainLayer = new TileLayer({
    source: new Stamen({
        layer: 'terrain'
    }),
    visible: false
});
