// @ART-label: "Color Harmonizer"
// @ART-param: ["tgt", "Teinte cible",    0.0, 360.0, 30.0,  1.0]
// @ART-param: ["src", "Teinte source",   0.0, 360.0, 120.0, 1.0]
// @ART-param: ["wid", "Largeur plage",   0.0, 180.0, 30.0,  1.0]
// @ART-param: ["str", "Force",           0.0, 1.0,   0.5,   0.01]
// @ART-param: ["fea", "Adoucissement",   0.0, 90.0,  10.0,  1.0]

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
    float str,
    float fea
)
{
    // ----- RGB -> HSL (sans fonctions mathématiques) -----
    float maxc = r;
    if (g > maxc) maxc = g;
    if (b > maxc) maxc = b;
    float minc = r;
    if (g < minc) minc = g;
    if (b < minc) minc = b;
    float delta = maxc - minc;

    float lum = (maxc + minc) / 2.0;

    float hue = 0.0;
    float sat = 0.0;

    if (delta != 0.0) {
        // saturation
        float diff = 2.0 * lum - 1.0;
        if (diff < 0.0) diff = -diff;
        float denom = 1.0 - diff;
        sat = delta / denom;

        // teinte
        float htmp;
        if (maxc == r) {
            htmp = (g - b) / delta;
            if (htmp < 0.0) htmp = htmp + 6.0;
            if (htmp >= 6.0) htmp = htmp - 6.0;
            htmp = htmp * 60.0;
        } else if (maxc == g) {
            htmp = ((b - r) / delta) + 2.0;
            if (htmp < 0.0) htmp = htmp + 6.0;
            if (htmp >= 6.0) htmp = htmp - 6.0;
            htmp = htmp * 60.0;
        } else { // maxc == b
            htmp = ((r - g) / delta) + 4.0;
            if (htmp < 0.0) htmp = htmp + 6.0;
            if (htmp >= 6.0) htmp = htmp - 6.0;
            htmp = htmp * 60.0;
        }
        // normalisation sécurité
        if (htmp < 0.0) htmp = htmp + 360.0;
        if (htmp >= 360.0) htmp = htmp - 360.0;
        hue = htmp;
    }

    // ----- Masque autour de la teinte source -----
    float dist = hue - src;
    if (dist > 180.0) dist = dist - 360.0;
    if (dist < -180.0) dist = dist + 360.0;
    float adist = dist;
    if (adist < 0.0) adist = -adist;   // abs
    float mask = 0.0;
    if (adist <= wid) {
        mask = 1.0;
    } else if (adist <= wid + fea) {
        mask = 1.0 - (adist - wid) / fea;
    } else {
        mask = 0.0;
    }

    // ----- Nouvelle teinte -----
    float dH = tgt - hue;
    if (dH > 180.0) dH = dH - 360.0;
    if (dH < -180.0) dH = dH + 360.0;
    float newHue = hue + dH * mask * str;
    if (newHue < 0.0) newHue = newHue + 360.0;
    if (newHue >= 360.0) newHue = newHue - 360.0;

    // ----- HSL -> RGB (variables locales distinctes des sorties) -----
    float ro;
    float go;
    float bo;

    if (sat == 0.0) {
        ro = lum;
        go = lum;
        bo = lum;
    } else {
        float q;
        if (lum < 0.5) {
            q = lum * (1.0 + sat);
        } else {
            q = lum + sat - lum * sat;
        }
        float p = 2.0 * lum - q;
        float hk = newHue / 360.0;

        // Rouge
        float tR = hk + 1.0/3.0;
        if (tR < 0.0) tR = tR + 1.0;
        if (tR > 1.0) tR = tR - 1.0;
        if (tR < 1.0/6.0) {
            ro = p + (q - p) * 6.0 * tR;
        } else if (tR < 0.5) {
            ro = q;
        } else if (tR < 2.0/3.0) {
            ro = p + (q - p) * (2.0/3.0 - tR) * 6.0;
        } else {
            ro = p;
        }

        // Vert
        float tG = hk;
        if (tG < 0.0) tG = tG + 1.0;
        if (tG > 1.0) tG = tG - 1.0;
        if (tG < 1.0/6.0) {
            go = p + (q - p) * 6.0 * tG;
        } else if (tG < 0.5) {
            go = q;
        } else if (tG < 2.0/3.0) {
            go = p + (q - p) * (2.0/3.0 - tG) * 6.0;
        } else {
            go = p;
        }

        // Bleu
        float tB = hk - 1.0/3.0;
        if (tB < 0.0) tB = tB + 1.0;
        if (tB > 1.0) tB = tB - 1.0;
        if (tB < 1.0/6.0) {
            bo = p + (q - p) * 6.0 * tB;
        } else if (tB < 0.5) {
            bo = q;
        } else if (tB < 2.0/3.0) {
            bo = p + (q - p) * (2.0/3.0 - tB) * 6.0;
        } else {
            bo = p;
        }
    }

    rout = ro;
    gout = go;
    bout = bo;
}
