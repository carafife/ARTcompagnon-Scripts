// @ART-label: "Color Harmonizer Pro (HSL curve)"
// @ART-colorspace: "rec2020"

import "_artlib";

// @ART-param: ["tgt", "Teinte cible", 0.0, 360.0, 30.0, 1.0]
// @ART-param: ["src", "Teinte source", 0.0, 360.0, 120.0, 1.0]
// @ART-param: ["wid", "Largeur plage", 0.0, 180.0, 30.0, 1.0]
// @ART-param: ["fea", "Adoucissement", 0.0, 90.0, 10.0, 1.0]
// Courbe de force : Y centré à 0.5 (50%) par défaut
// @ART-param: ["strcurve", "Force", 2, ["ControlPoints", 0.0, 0.5, 0.35, 0.35, 0.25, 0.5, 0.35, 0.35, 0.5, 0.5, 0.35, 0.35, 0.75, 0.5, 0.35, 0.35, 1.0, 0.5, 0.35, 0.35], [[0.0, 0.6, 0.3, 0.5], [0.25, 0.6, 0.5, 0.3], [0.5, 0.5, 0.6, 0.3], [0.75, 0.3, 0.6, 0.5], [1.0, 0.6, 0.3, 0.5]], 0, "$CTL_CHANNEL;Channel"]

void ART_main(
    varying float r,
    varying float g,
    varying float b,
    output varying float rout,
    output varying float gout,
    output varying float bout,
    float tgt,
    float src,
    float wid,
    float fea,
    float strcurve[256]
)
{
    // Conversion du pixel en OKLCh
    float hsl[3] = rgb2okhcl(r, g, b);
    float px_hue = hsl[0];   // radians
    float px_sat = hsl[1];
    float px_lum = hsl[2];

    // Conversion des teintes cible et source en radians
    float tgt_rad = tgt * M_PI / 180.0;
    float src_rad = src * M_PI / 180.0;

    // Distance angulaire à la teinte source
    float dh_rad = px_hue - src_rad;
    if (dh_rad > M_PI) {
        dh_rad = dh_rad - 2.0 * M_PI;
    }
    if (dh_rad < -M_PI) {
        dh_rad = dh_rad + 2.0 * M_PI;
    }
    float dh_deg = dh_rad * 180.0 / M_PI;
    float adist;
    if (dh_deg < 0.0) {
        adist = -dh_deg;
    } else {
        adist = dh_deg;
    }

    // Masque
    float mask;
    if (adist <= wid) {
        mask = 1.0;
    } else if (adist <= wid + fea) {
        mask = 1.0 - (adist - wid) / fea;
    } else {
        mask = 0.0;
    }

    // Force via courbe, teinte normalisée [0,1]
    float h01 = px_hue / (2.0 * M_PI);
    if (h01 < 0.0) {
        h01 = h01 + 1.0;
    }
    if (h01 >= 1.0) {
        h01 = h01 - 1.0;
    }
    float str_val = luteval(strcurve, h01);

    // Déplacement vers la teinte cible
    float delta_rad = tgt_rad - px_hue;
    if (delta_rad > M_PI) {
        delta_rad = delta_rad - 2.0 * M_PI;
    }
    if (delta_rad < -M_PI) {
        delta_rad = delta_rad + 2.0 * M_PI;
    }
    float new_hue = px_hue + delta_rad * mask * str_val;

    // Reconstruction RGB
    float new_hsl[3];
    new_hsl[0] = new_hue;
    new_hsl[1] = px_sat;
    new_hsl[2] = px_lum;
    float new_rgb[3] = okhcl2rgb(new_hsl);
    rout = new_rgb[0];
    gout = new_rgb[1];
    bout = new_rgb[2];
}
