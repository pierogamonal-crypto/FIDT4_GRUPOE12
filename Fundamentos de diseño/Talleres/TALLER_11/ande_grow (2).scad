// ============================================================================
// PROYECTO: ANDE-GROW - Invernadero Inteligente para Zonas Altoandinas
// Versión 2: carcasas imprimibles + electrónica ilustrativa + cableado
// Impresora objetivo: Creality Ender-3 S1 (Cama: 220 x 220 x 270 mm)
// Material: PLA | Unidades: Milímetros (mm)
// Probado con OpenSCAD 2021.01
// ============================================================================
//
// DOS TIPOS DE PIEZAS (no confundir):
//   * IMPRIMIBLES (PLA)  : caja, tapa, soporte DHT22, DS18B20 int/ext, BH1750.
//   * ILUSTRATIVAS      : ESP32, sensores, placa auxiliar, resistencias y cables.
//                         Solo existen en los modos de visualización. NUNCA se imprimen.
//
// REGLA PARA EXPORTAR STL: usar únicamente los modos de la lista "IMPRIMIBLES".
// Los modos "VISUALES" mezclan piezas ilustrativas y no sirven para exportar.

$fn = 64;
eps = 0.05; // Margen para operaciones booleanas limpias (evita caras coplanares)

// ============================================================================
// 1. SELECTOR DE MODO
// ============================================================================
// --- IMPRIMIBLES (exportar STL con F6 + F7) ---
//   "caja_base"      -> Caja de control
//   "caja_tapa"      -> Tapa de la caja
//   "dht22"          -> Carcasa ventilada DHT22
//   "ds18b20_int"    -> Soporte DS18B20 interior
//   "ds18b20_ext"    -> Soporte DS18B20 exterior con capucha
//   "bh1750"         -> Soporte BH1750
//   "kit_placa_1"    -> Placa de impresión 1 (caja + DHT22 + DS18B20 ext)
//   "kit_placa_2"    -> Placa de impresión 2 (tapa + DS18B20 int + BH1750)
//   "kit_impresion"  -> Las dos placas lado a lado (solo para ver)
//   "lote_soportes"  -> Los 4 soportes juntos en una cama (versión anterior)
//   "ensamble_caja"  -> Caja + tapa (verificación de encaje)
//   "vista_general"  -> Las 6 piezas separadas (versión anterior)
// --- VISUALES (NO exportar) ---
//   "vista_sensores"      -> Cada sensor con sus cables de salida y leyenda de colores
//   "caja_ensamblada"     -> Caja abierta: ESP32 + placa auxiliar + cableado interno
//   "ensamblaje_completo" -> Caja + tapa al costado + 4 sensores + cables hasta la caja
//   "caja_cerrada"        -> Caja con la tapa puesta (comprobar el encaje)

modo_exportacion = "ensamblaje_completo";

// Herramientas de visualización (no afectan a los STL imprimibles):
mostrar_cama_ender3 = true;    // Cama 220x220 en gris transparente (modos de impresión)
corte_seccion_caja  = false;   // En "ensamble_caja": corta a la mitad para ver holgura
estado_tapa         = "al_lado"; // Modos visuales: "al_lado" (en el plano Z=0, como se imprime) | "cerrada" | "oculta"
mostrar_electronica = true;    // false = oculta todo lo ilustrativo (solo carcasas)
mostrar_etiquetas   = true;    // Textos (pines, redes, leyendas)
sensores_dist_y     = 70;      // "ensamblaje_completo": distancia sensores - pared frontal
largo_cable_corto   = 30;      // Largo del cable que sale de la caja en "caja_ensamblada"

// ============================================================================
// 2. PARÁMETROS GLOBALES DE FABRICACIÓN (PLA - FDM)
// ============================================================================
espesor_pared       = 3.0;
holgura_uniones     = 0.4;
holgura_sonda       = 0.4;
separacion_piezas   = 15.0;
diam_tornillo_m3    = 3.2;
diam_rosca_m3       = 2.7;
diam_tornillo_viga  = 4.2;

// ============================================================================
// 3. PARÁMETROS DE PIEZAS IMPRIMIBLES
// ============================================================================

// --- A. CAJA CENTRAL Y TAPA ---
usar_caja_180x140   = false;   // false = 130x115x45 | true = 180x140x65

caja_largo          = usar_caja_180x140 ? 180.0 : 130.0;
caja_ancho          = usar_caja_180x140 ? 140.0 : 115.0;
caja_alto           = usar_caja_180x140 ? 65.0  : 45.0;
espesor_tapa        = 4.0;
altura_labio_tapa   = 3.5;
diam_orificio_cable = 12.0;
num_orificios_cable = 4;       // 1 por sensor: 0=DHT22, 1=DS18B20 int, 2=DS18B20 ext, 3=BH1750

// Soportes internos (ESP32 y placa auxiliar)
incluir_postes_pcb  = true;
usb_abertura        = true;    // Ventana en la pared izquierda para el cable USB del ESP32
usb_corte_ancho     = 14.0;
usb_corte_alto      = 9.0;

// --- B. CARCASA VENTILADA DHT22 ---
dht22_ancho_ext     = 32.0;
dht22_fondo_ext     = 22.0;
dht22_alto_ext      = 48.0;
dht22_alero_lluvia  = 4.0;
// (la boca de inserción del sensor se calcula más abajo a partir de las medidas del DHT22)
dht22_holgura_int   = 1.0;     // PENDIENTE DE CONFIRMAR CON MÓDULO DHT22 REAL

// --- C y D. SOPORTES DE SONDA DS18B20 ---
diam_sonda_ds18b20  = 6.0;
ds18b20_int_alto    = 18.0;
ds18b20_ext_alto    = 36.0;
ds18b20_ext_capucha = 8.0;
ds18b20_sep_termica = 8.0;

// --- E. SOPORTE SENSOR BH1750 ---
bh1750_pcb_largo    = 18.0;    // PENDIENTE DE CONFIRMAR CON PLACA GY-302 REAL
bh1750_pcb_ancho    = 14.5;
bh1750_pcb_espesor  = 1.8;
bh1750_dist_torn    = 10.0;
bh1750_diam_torn    = 2.4;
bh1750_alto_base    = 10.0;

// ============================================================================
// 4. PARÁMETROS DE LA ELECTRÓNICA ILUSTRATIVA Y EL CABLEADO
// ============================================================================

// --- GPIO del ESP32 (PROPUESTA DE DISEÑO: validar con el esquema definitivo) ---
gpio_dht22      = 4;     // DHT22  DATA
gpio_ds18b20    = 5;     // DS18B20 (bus 1-Wire compartido por interior y exterior)
gpio_sda        = 21;    // BH1750 SDA (I2C)
gpio_scl        = 22;    // BH1750 SCL (I2C)

// --- Placa ESP32 (referencia: DevKit V1 de 30 pines) ---
// PENDIENTE DE CONFIRMAR CON LA PLACA REAL: dimensiones, separación de filas y orden de pines.
esp32_largo         = 51.5;
esp32_ancho         = 28.3;
esp32_espesor_pcb   = 1.6;
esp32_sep_filas     = 22.86;   // Distancia entre las dos filas de pines
esp32_paso          = 2.54;
esp32_num_pines     = 15;
esp32_offset_pines  = 0.0;     // Desplazamiento de la fila de pines a lo largo de la placa
esp32_alto_poste    = 5.0;     // Altura del soporte bajo la placa
esp32_holg_retenedor= 0.5;    // Holgura de la placa en los retenedores (medir la placa real con calibre)
esp32_dupont_alto   = 12.0;    // Largo del conector Dupont hembra
// Orden de pines de cada fila, de la antena hacia el USB (números = GPIO)
esp32_pines_der = [23, 22, "TX0", "RX0", 21, 19, 18, 5, 17, 16, 4, 2, 15, "GND", "3V3"];
esp32_pines_izq = ["EN", "VP", "VN", 34, 35, 32, 33, 25, 26, 27, 14, 12, 13, "GND", "VIN"];

// --- Sensores (cuerpos ilustrativos) ---
// PENDIENTE DE CONFIRMAR CON LOS COMPONENTES REALES
dht22_s_largo       = 25.0;    // Cuerpo DHT22 (AM2302 sin módulo)
dht22_s_ancho       = 15.1;
dht22_s_espesor     = 7.7;
dht22_pin_largo     = 7.0;
dht22_pin_paso      = 2.54;
dht22_holg_insercion= 1.0;     // Holgura por lado para meter el sensor (FDM: usar >= 0,5 mm)
// Boca de inserción en la cara inferior del soporte DHT22 (el sensor entra por aquí y el cable sale por aquí)
dht22_boca_ancho    = dht22_s_ancho   + 2*dht22_holg_insercion;   // 17,1 mm
dht22_boca_alto     = dht22_s_espesor + 2*dht22_holg_insercion;   //  9,7 mm
ds18b20_tubo_largo  = 30.0;    // Tubo de acero inoxidable de la sonda
ds18b20_boot_d      = 5.0;     // Termorretráctil donde nace el cable
ds18b20_boot_largo  = 6.0;

// --- Cables ---
d_hilo   = 1.2;                // Diámetro de cada conductor aislado
d_funda  = 4.4;                // Diámetro de la funda del cable de cada sensor

// --- Placa auxiliar (perforada) con barras de red y resistencias pull-up ---
aux_alto_poste  = 4.0;
aux_espesor     = 1.6;
aux_inset       = 3.5;
aux_paso_lane   = 4.5;         // Separación entre barras de red
aux_sep_pads    = 3.6;         // Separación entre cables de un mismo sensor al llegar a la placa
r_pullup_ds     = "4.7k";      // DS18B20: 4,7 kΩ entre DATA y 3V3
r_pullup_dht    = "10k";       // DHT22 (sensor sin módulo): 4,7 - 10 kΩ entre DATA y 3V3

// --- Colores (convención visual; NO sustituye a las etiquetas) ---
color_pla    = [0.88, 0.86, 0.80];
c_3v3 = [0.90, 0.10, 0.10];    // Rojo     : 3,3 V
c_gnd = [0.10, 0.10, 0.10];    // Negro    : GND
c_dht = [1.00, 0.85, 0.00];    // Amarillo : DATA del DHT22
c_ds  = [0.10, 0.35, 1.00];    // Azul     : bus DATA de los DS18B20
c_sda = [0.10, 0.75, 0.25];    // Verde    : SDA
c_scl = [1.00, 0.50, 0.00];    // Naranja  : SCL
color_funda  = [0.28, 0.28, 0.32];
color_acero  = [0.80, 0.82, 0.86];
color_oro    = [0.90, 0.75, 0.25];
color_pcb_esp= [0.10, 0.10, 0.13];

// ============================================================================
// 5. FUNCIONES Y DATOS DE CABLEADO
// ============================================================================

// Redes, de ATRÁS hacia ADELANTE en la placa auxiliar (orden = orden de pines del ESP32)
redes = ["3V3", "GND", "DHT", "DS", "SDA", "SCL"];

// Conductores de cada sensor (en el orden de sus pines)
sensores_nombre = ["DHT22", "DS18B20 INT", "DS18B20 EXT", "BH1750"];
sensores_redes  = [ ["3V3", "DHT", "GND"],
                    ["3V3", "DS",  "GND"],
                    ["3V3", "DS",  "GND"],
                    ["3V3", "GND", "SCL", "SDA"] ];
sens_x  = [-90, -30, 30, 90];       // Posición X de cada sensor en las vistas
sens_rz = [180, 0, 0, 180];         // Giro Z para que el cable salga hacia la caja (+Y)

function idx_en(v, lst) = let(r = [for (i = [0:len(lst)-1]) if (lst[i] == v) i]) len(r) > 0 ? r[0] : undef;
function unit(v) = v / norm(v);
function rotz(p, a) = [p[0]*cos(a) - p[1]*sin(a), p[0]*sin(a) + p[1]*cos(a), p[2]];

// Curva de Bézier de grado arbitrario (De Casteljau)
function bez_pt(p, t) = len(p) == 1 ? p[0] : bez_pt([for (i = [0:len(p)-2]) (1-t)*p[i] + t*p[i+1]], t);
function bez(p, n = 14) = [for (i = [0:n]) bez_pt(p, i/n)];

// Posición X / Z de los orificios de cable (misma fórmula que usa la caja)
function x_pasacable(i) = -((caja_largo - 48)/2) + i * (caja_largo - 48) / max(1, (num_orificios_cable - 1));
z_pasacable = espesor_pared + diam_orificio_cable/2 + 8;

function color_red(n) = n == "3V3" ? c_3v3 : n == "GND" ? c_gnd : n == "DHT" ? c_dht
                      : n == "DS" ? c_ds : n == "SDA" ? c_sda : c_scl;
function lane_txt(n) = n == "DS" ? "DS18" : n;
function pin_esp_de_red(n) = n == "DHT" ? gpio_dht22 : n == "DS" ? gpio_ds18b20
                           : n == "SDA" ? gpio_sda : n == "SCL" ? gpio_scl : n;   // 3V3 y GND son pines con ese nombre
function pin_txt(v) = is_num(v) ? str("G", v) : v;

// --- Distribución interior (calculada a partir de la caja) ---
y_funda_in      = -caja_ancho/2 + espesor_pared + 7.5;      // Donde termina la funda dentro de la caja
aux_y_ad        = -caja_ancho/2 + espesor_pared + 10.5;     // Borde frontal de la placa auxiliar
aux_y_lane_fr   = aux_y_ad + 5.5;                           // Barra más cercana a los cables (SCL)
aux_y_at        = aux_y_lane_fr + (len(redes)-1)*aux_paso_lane + 5.5;   // Borde trasero
aux_x_esp       = -caja_largo/2 + espesor_pared + 14;       // Columna de pads donde llegan los cables del ESP32
aux_x0          = aux_x_esp - 9;
aux_x1          = x_pasacable(num_orificios_cable-1) + 10;
aux_z_base      = espesor_pared + aux_alto_poste;           // Cara inferior de la placa auxiliar
aux_z_pad       = aux_z_base + aux_espesor + 1.0;           // Cara superior de los pads

esp32_z_pcb     = espesor_pared + esp32_alto_poste;
esp32_cx        = -caja_largo/2 + espesor_pared + 5 + esp32_largo/2;
esp32_cy        = aux_y_at + 16 + esp32_ancho/2;
esp32_z_dupont  = esp32_z_pcb + esp32_espesor_pcb + 2.5 + esp32_dupont_alto;  // Parte alta del conector

function lane_idx(n) = idx_en(n, redes);
function lane_y(n) = aux_y_lane_fr + (len(redes)-1 - lane_idx(n)) * aux_paso_lane;

function tiene(k, n) = len([for (m = sensores_redes[k]) if (m == n) 1]) > 0;
function rank_red(k, n) = len([for (m = sensores_redes[k]) if (lane_idx(m) > lane_idx(n)) 1]);  // 0 = barra más cercana
function pad_x(k, n) = x_pasacable(k) + (rank_red(k, n) - (len(sensores_redes[k])-1)/2) * aux_sep_pads;

// Resistencias pull-up: [red de datos, valor, posición X]
res_x1 = (x_pasacable(0) + x_pasacable(1))/2 - 3;
res_x2 = (x_pasacable(0) + x_pasacable(1))/2 + 3;
resistencias = [ ["DHT", r_pullup_dht, res_x1], ["DS", r_pullup_ds, res_x2] ];
function pads_res(n) = [for (r = resistencias) if (n == "3V3" || n == r[0]) r[2]];
function pads_x(n) = concat([aux_x_esp], [for (k = [0:3]) if (tiene(k, n)) pad_x(k, n)], pads_res(n));

// Pines del ESP32
function pin_col(v) = idx_en(v, esp32_pines_der) != undef ? 1 : (idx_en(v, esp32_pines_izq) != undef ? -1 : 0);
function pin_idx(v) = pin_col(v) == 1 ? idx_en(v, esp32_pines_der) : idx_en(v, esp32_pines_izq);
function pin_local(v) = [pin_col(v) * esp32_sep_filas/2,
                         ((esp32_num_pines-1)/2 - pin_idx(v)) * esp32_paso + esp32_offset_pines];
function pin_world(v) = [esp32_cx + pin_local(v)[1], esp32_cy - pin_local(v)[0], 0];   // placa girada -90° en Z
function color_pin(col, i) = let(r = [for (n = redes)
                                         if (pin_col(pin_esp_de_red(n)) == col && pin_idx(pin_esp_de_red(n)) == i) color_red(n)])
                             len(r) > 0 ? r[0] : [0.92, 0.92, 0.92];

// Datos de cada soporte (puntos donde nace la funda del cable de cada sensor)
function ds_d_ext() = diam_sonda_ds18b20 + holgura_sonda + 2*espesor_pared;
function ds_zc_ext() = espesor_pared + ds18b20_sep_termica + ds_d_ext()/2;
function bh_ancho_ext() = bh1750_pcb_ancho + 2*holgura_uniones + 2*espesor_pared;
function bh_z_pcb() = bh1750_alto_base - bh1750_pcb_espesor + eps/2;   // asienta sobre el fondo del rebaje
dht22_z_cuerpo = 4.6;   // Cota Z donde apoya el cuerpo del DHT22 (fondo de la cavidad + 0,1)
function S_local(k) = k == 0 ? [0, -dht22_alto_ext/2 - 6, dht22_z_cuerpo + dht22_s_espesor/2]
                    : k == 1 ? [0, 0, ds18b20_int_alto + 4 + ds18b20_boot_largo]
                    : k == 2 ? [0, ds18b20_ext_alto/2 - ds18b20_ext_capucha/2 + ds18b20_boot_largo, ds_zc_ext()]
                    :          [0, -bh_ancho_ext()/2 - 8, bh_z_pcb() - 3];
function D_local(k) = k == 0 ? [0, -1, 0] : k == 1 ? [0, 0, 1] : k == 2 ? [0, 1, 0] : [0, -1, 0];
function S_mundo(k, y0) = [sens_x[k], y0, 0] + rotz(S_local(k), sens_rz[k]);
function D_mundo(k) = rotz(D_local(k), sens_rz[k]);

// Posición (dx, dz) de cada conductor dentro de la funda, según cuántos conductores tiene
function arr_fin(m, r) = m == 3 ? [[-1.0, -0.5], [0.0, 0.9], [1.0, -0.5]][r]
                                : [[-1.5, 0.0], [-0.5, 0.8], [0.5, -0.8], [1.5, 0.0]][r];

// Posición X de la tapa al costado de la caja (deja separacion_piezas libres entre las orejas de la caja y la tapa)
tapa_x_lado = caja_largo + 12 + separacion_piezas;

modos_imprimibles = ["caja_base","caja_tapa","dht22","ds18b20_int","ds18b20_ext","bh1750",
                     "kit_placa_1","kit_placa_2","lote_soportes","ensamble_caja","vista_general"];
exportable = len([for (m = modos_imprimibles) if (m == modo_exportacion) 1]) > 0;

// ============================================================================
// 6. UTILIDADES GEOMÉTRICAS
// ============================================================================
module bloque(a, b) {
    translate([min(a[0], b[0]), min(a[1], b[1]), min(a[2], b[2])])
        cube([abs(b[0]-a[0]), abs(b[1]-a[1]), abs(b[2]-a[2])]);
}

// Tubo flexible: polilínea de esferas unidas (cables)
module tubo_ruta(pts, d, col, fn = 8) {
    color(col)
    for (i = [0 : len(pts)-2])
        hull() {
            translate(pts[i])   sphere(d = d, $fn = fn);
            translate(pts[i+1]) sphere(d = d, $fn = fn);
        }
}
module tubo_bezier(ctrl, d, col, n = 14, fn = 8) { tubo_ruta(bez(ctrl, n), d, col, fn); }

module imprimible() { color(color_pla) children(); }
module ilustrativo() { if (mostrar_electronica) children(); }

// ============================================================================
// MÓDULO A1: CAJA CENTRAL PARA LA ELECTRÓNICA (BASE)  [IMPRIMIBLE]
// ============================================================================
module caja_control_base() {
    r_poste = 5.5;
    x_poste = caja_largo/2 - espesor_pared - r_poste + 1.5;
    y_poste = caja_ancho/2 - espesor_pared - r_poste + 1.5;

    difference() {
        union() {
            translate([0, 0, caja_alto/2])
            union() {
                difference() {
                    union() {
                        cube([caja_largo, caja_ancho, caja_alto], center=true);

                        // 4 orejas de fijación a nivel de cama
                        for (sx = [-1, 1], sy = [-1, 1]) {
                            translate([sx * (caja_largo/2 + 6), sy * (caja_ancho/2 - 14), -caja_alto/2 + espesor_pared/2])
                            difference() {
                                cube([12 + eps, 18, espesor_pared], center=true);
                                translate([sx * 1.5, 0, 0])
                                    cylinder(d = diam_tornillo_viga, h = espesor_pared + 2*eps, center=true);
                            }
                        }
                    }

                    // Vaciado interior
                    translate([0, 0, espesor_pared/2 + eps])
                        cube([caja_largo - 2*espesor_pared, caja_ancho - 2*espesor_pared, caja_alto - espesor_pared + eps], center=true);

                    // Orificios de cable en la pared frontal (-Y)
                    for (i = [0 : num_orificios_cable - 1]) {
                        translate([x_pasacable(i), -caja_ancho/2, -caja_alto/2 + z_pasacable])
                            rotate([90, 0, 0])
                            cylinder(d = diam_orificio_cable, h = espesor_pared * 3, center=true);
                    }
                }

                // 4 columnas esquineras para atornillar la tapa
                for (sx = [-1, 1], sy = [-1, 1]) {
                    translate([sx * x_poste, sy * y_poste, 0])
                    difference() {
                        cylinder(r = r_poste, h = caja_alto, center=true);
                        translate([0, 0, caja_alto/2 - 9 + eps])
                            cylinder(d = diam_rosca_m3, h = 18, center=true);
                    }
                }
            }

            // Soportes internos para el ESP32 y la placa auxiliar
            if (incluir_postes_pcb) soportes_internos_pcb();
        }

        // Ventana para el cable USB del ESP32 (pared izquierda, -X)
        if (usb_abertura) corte_usb_esp32();
    }
}

// Ventana USB: centrada en el conector micro-USB del ESP32
module corte_usb_esp32() {
    z_usb = esp32_z_pcb + esp32_espesor_pcb + 1.3;
    translate([-caja_largo/2 - 1, esp32_cy - usb_corte_ancho/2, z_usb - usb_corte_alto/2])
        cube([espesor_pared + 1 + eps, usb_corte_ancho, usb_corte_alto]);
}

// Retenedor en L para una esquina del ESP32 (las DevKit no traen agujeros de montaje)
module soporte_esquina_pcb(cx, cy, sx, sy) {
    zp  = esp32_z_pcb;
    zt  = zp + esp32_espesor_pcb + 1.5;
    h   = esp32_holg_retenedor;
    w   = 1.6;     // espesor de los topes (>= 1,2 mm = 3 perímetros con boquilla de 0,4)
    ent = 4.5;
    bloque([cx - sx*ent, cy - sy*ent, espesor_pared - eps], [cx + sx*(h+w), cy + sy*(h+w), zp]);   // poste
    bloque([cx - sx*ent, cy + sy*h,   zp - eps],            [cx + sx*(h+w), cy + sy*(h+w), zt]);   // tope borde X
    bloque([cx + sx*h,   cy - sy*ent, zp - eps],            [cx + sx*(h+w), cy + sy*(h+w), zt]);   // tope borde Y
}

// 4 postes con rosca M3 para la placa auxiliar
module postes_aux() {
    for (px = [aux_x0 + aux_inset, aux_x1 - aux_inset], py = [aux_y_ad + aux_inset, aux_y_at - aux_inset])
        translate([px, py, espesor_pared - eps])
        difference() {
            cylinder(d = 6.5, h = aux_alto_poste + eps);
            translate([0, 0, 0.5]) cylinder(d = diam_rosca_m3, h = aux_alto_poste);
        }
}

module soportes_internos_pcb() {
    for (sx = [-1, 1], sy = [-1, 1])
        soporte_esquina_pcb(esp32_cx + sx*esp32_largo/2, esp32_cy + sy*esp32_ancho/2, sx, sy);
    postes_aux();
}

// ============================================================================
// MÓDULO A2: TAPA INDEPENDIENTE Y DESMONTABLE  [IMPRIMIBLE]
// ============================================================================
module caja_control_tapa() {
    r_poste = 5.5;
    x_poste = caja_largo/2 - espesor_pared - r_poste + 1.5;
    y_poste = caja_ancho/2 - espesor_pared - r_poste + 1.5;

    largo_labio = caja_largo - 2*espesor_pared - 2*holgura_uniones;
    ancho_labio = caja_ancho - 2*espesor_pared - 2*holgura_uniones;

    difference() {
        union() {
            translate([0, 0, espesor_tapa/2])
                cube([caja_largo, caja_ancho, espesor_tapa], center=true);
            translate([0, 0, espesor_tapa + altura_labio_tapa/2 - eps])
                cube([largo_labio, ancho_labio, altura_labio_tapa + eps], center=true);
        }

        translate([0, 0, espesor_tapa + altura_labio_tapa/2 + eps])
            cube([largo_labio - 2*espesor_pared, ancho_labio - 2*espesor_pared, altura_labio_tapa + 2*eps], center=true);

        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * x_poste, sy * y_poste, espesor_tapa + altura_labio_tapa/2])
                cylinder(r = r_poste + holgura_uniones, h = altura_labio_tapa + 4*eps, center=true);
            translate([sx * x_poste, sy * y_poste, (espesor_tapa + altura_labio_tapa)/2])
                cylinder(d = diam_tornillo_m3, h = espesor_tapa + altura_labio_tapa + 4*eps, center=true);
        }
    }
}

// ============================================================================
// MÓDULO B: SOPORTE Y PROTECCIÓN VENTILADA PARA SENSOR DHT22  [IMPRIMIBLE]
// ============================================================================
module soporte_dht22() {
    ancho_int = dht22_ancho_ext - 2*espesor_pared + dht22_holgura_int;
    fondo_int = dht22_fondo_ext - 2*espesor_pared;
    alto_int  = dht22_alto_ext  - 2*espesor_pared;

    translate([0, 0, dht22_fondo_ext/2])
    union() {
        difference() {
            union() {
                cube([dht22_ancho_ext, dht22_alto_ext, dht22_fondo_ext], center=true);

                translate([0, dht22_alto_ext/2 - espesor_pared/2, dht22_alero_lluvia/2])
                    cube([dht22_ancho_ext + 4, espesor_pared, dht22_fondo_ext + dht22_alero_lluvia], center=true);

                for (sx = [-1, 1]) {
                    translate([sx * (dht22_ancho_ext/2 + 6), 0, -dht22_fondo_ext/2 + espesor_pared/2])
                        cube([12 + eps, 16, espesor_pared], center=true);
                }
            }

            translate([0, -espesor_pared/2, espesor_pared/2])
                cube([ancho_int, alto_int, fondo_int + eps], center=true);

            for (y_slot = [-12 : 7 : 10]) {
                translate([0, y_slot, dht22_fondo_ext/2 - espesor_pared/2])
                    rotate([45, 0, 0])
                    cube([ancho_int - 4, 3.0, espesor_pared * 3], center=true);

                translate([0, y_slot, 2])
                    cube([dht22_ancho_ext + 2*eps, 3.0, fondo_int - 4], center=true);
            }

            // Boca de inserción: ancha para que entre el cuerpo del sensor (15,1 x 7,7 mm).
            // Arranca a ras del piso de la cavidad para que el sensor deslice sin tropezar.
            z_piso_l = espesor_pared/2 - (fondo_int + eps)/2;   // piso de la cavidad (coord. locales)
            translate([0, -dht22_alto_ext/2, z_piso_l + dht22_boca_alto/2 - eps])
                cube([dht22_boca_ancho, espesor_pared * 3, dht22_boca_alto + 2*eps], center=true);

            for (sx = [-1, 1]) {
                translate([sx * (dht22_ancho_ext/2 + 6.5), 0, -dht22_fondo_ext/2 + espesor_pared/2])
                    cylinder(d = diam_tornillo_viga, h = espesor_pared + 2*eps, center=true);
            }
        }
    }
}

// ============================================================================
// MÓDULO C: SOPORTE PARA SONDA DS18B20 INTERIOR  [IMPRIMIBLE]
// ============================================================================
module soporte_ds18b20_interior() {
    d_agujero  = diam_sonda_ds18b20 + holgura_sonda;
    d_exterior = d_agujero + 2*espesor_pared;
    apertura_c = d_agujero * 0.72;

    translate([0, 0, ds18b20_int_alto/2])
    difference() {
        union() {
            cylinder(d = d_exterior, h = ds18b20_int_alto, center=true);
            translate([0, d_exterior/4 + 1.5, 0])
                cube([d_exterior, d_exterior/2 + 3, ds18b20_int_alto], center=true);
            translate([0, d_exterior/2 + 3 - espesor_pared/2, 0])
                cube([d_exterior + 22, espesor_pared, ds18b20_int_alto], center=true);
        }

        cylinder(d = d_agujero, h = ds18b20_int_alto + 2*eps, center=true);

        translate([0, -d_exterior/2, 0])
            cube([apertura_c, d_exterior, ds18b20_int_alto + 2*eps], center=true);

        for (sx = [-1, 1]) {
            translate([sx * (d_exterior/2 + 6), d_exterior/2 + 3 - espesor_pared/2, 0])
                rotate([90, 0, 0])
                cylinder(d = diam_tornillo_viga, h = espesor_pared + 4*eps, center=true);
        }
    }
}

// ============================================================================
// MÓDULO D: SOPORTE PARA SONDA DS18B20 EXTERIOR (CON CAPUCHA)  [IMPRIMIBLE]
// ============================================================================
module soporte_ds18b20_exterior() {
    d_agujero  = diam_sonda_ds18b20 + holgura_sonda;
    d_exterior = d_agujero + 2*espesor_pared;
    alto_total = ds18b20_ext_alto + ds18b20_ext_capucha;
    y_centro_sonda = espesor_pared + ds18b20_sep_termica + d_exterior/2;

    translate([0, 0, 0])
    difference() {
        union() {
            translate([0, 0, espesor_pared/2])
                cube([d_exterior + 24, alto_total, espesor_pared], center=true);

            translate([0, 0, (y_centro_sonda)/2])
                cube([espesor_pared * 2, alto_total, y_centro_sonda], center=true);

            translate([0, -ds18b20_ext_capucha/2, y_centro_sonda])
                rotate([90, 0, 0])
                cylinder(d = d_exterior, h = ds18b20_ext_alto, center=true);

            translate([0, ds18b20_ext_alto/2, y_centro_sonda])
                rotate([90, 0, 0])
                cylinder(d1 = d_exterior, d2 = d_exterior + 4, h = ds18b20_ext_capucha, center=true);
        }

        translate([0, -ds18b20_ext_capucha/2 - eps, y_centro_sonda])
            rotate([90, 0, 0])
            cylinder(d = d_agujero, h = ds18b20_ext_alto + 2*eps, center=true);

        translate([0, ds18b20_ext_alto/2, y_centro_sonda])
            rotate([90, 0, 0])
            cylinder(d = d_agujero - 1.0, h = ds18b20_ext_capucha + 4*eps, center=true);

        translate([0, 0, y_centro_sonda + d_exterior/2])
            cube([d_agujero * 0.72, alto_total + 2*eps, d_exterior], center=true);

        translate([0, -ds18b20_ext_capucha/2, y_centro_sonda])
            cube([d_exterior + 4*eps, 14.0, d_exterior + 2], center=true);

        translate([0, -ds18b20_ext_capucha/2, espesor_pared + ds18b20_sep_termica/2])
            cube([d_exterior + 4*eps, 16.0, ds18b20_sep_termica - 1], center=true);

        for (sx = [-1, 1]) {
            translate([sx * (d_exterior/2 + 6.5), 0, espesor_pared/2])
                cylinder(d = diam_tornillo_viga, h = espesor_pared + 4*eps, center=true);
        }
    }
}

// ============================================================================
// MÓDULO E: SOPORTE PARA SENSOR DE LUMINOSIDAD BH1750  [IMPRIMIBLE]
// ============================================================================
module soporte_bh1750() {
    largo_int = bh1750_pcb_largo + 2*holgura_uniones;
    ancho_int = bh1750_pcb_ancho + 2*holgura_uniones;
    largo_ext = largo_int + 2*espesor_pared;
    ancho_ext = ancho_int + 2*espesor_pared;
    alto_base = bh1750_alto_base;

    translate([0, 0, alto_base/2])
    difference() {
        union() {
            cube([largo_ext, ancho_ext, alto_base], center=true);
            for (sx = [-1, 1]) {
                translate([sx * (largo_ext/2 + 6), 0, -alto_base/2 + espesor_pared/2])
                    cube([12 + eps, ancho_ext, espesor_pared], center=true);
            }
        }

        translate([0, 0, alto_base/2 - bh1750_pcb_espesor/2 + eps])
            cube([largo_int, ancho_int, bh1750_pcb_espesor + eps], center=true);

        translate([0, -2, espesor_pared/2])
            cube([largo_int - 3.0, ancho_int + espesor_pared, alto_base - espesor_pared + eps], center=true);

        for (sx = [-1, 1]) {
            translate([sx * (bh1750_dist_torn/2), 0, 0])
                cylinder(d = bh1750_diam_torn, h = alto_base + 2*eps, center=true);
        }

        for (sx = [-1, 1]) {
            translate([sx * (largo_ext/2 + 6.5), 0, -alto_base/2 + espesor_pared/2])
                cylinder(d = diam_tornillo_viga, h = espesor_pared + 2*eps, center=true);
        }
    }
}

// ============================================================================
// 7. ELECTRÓNICA ILUSTRATIVA  (NO SE IMPRIME)
// ============================================================================

// --- ESP32 DevKit (coordenadas locales: ancho en X, largo en Y, antena +Y, USB -Y) ---
module esp32_placa() {
    L = esp32_largo; W = esp32_ancho; T = esp32_espesor_pcb;
    color(color_pcb_esp) translate([-W/2, -L/2, 0]) cube([W, L, T]);

    // Módulo WROOM: PCB + blindaje metálico (la zona de antena queda sin blindaje)
    color([0.10, 0.10, 0.12]) translate([-9, L/2 - 25.5, T]) cube([18, 25.5, 0.8]);
    color([0.78, 0.78, 0.80]) translate([-9, L/2 - 25.5, T + 0.8]) cube([18, 19.2, 2.3]);

    // Conector micro-USB (sobresale del borde)
    color([0.80, 0.80, 0.83]) translate([-3.75, -L/2 - 1.2, T]) cube([7.5, 5.7, 2.6]);

    // Botones EN / BOOT y chip USB-serie
    for (sx = [-1, 1]) {
        color([0.1, 0.1, 0.1]) translate([sx*8 - 1.8, -L/2 + 7.2, T]) cube([3.6, 3.6, 1.2]);
        color([0.9, 0.9, 0.9]) translate([sx*8, -L/2 + 9, T + 1.2]) cylinder(d = 2, h = 0.8, $fn = 16);
    }
    color([0.1, 0.1, 0.1]) translate([-2.5, -L/2 + 14, T]) cube([5, 5, 1.0]);

    // Filas de pines (hacia arriba) y rotulado
    for (col = [-1, 1], i = [0 : esp32_num_pines - 1]) {
        px = col * esp32_sep_filas/2;
        py = ((esp32_num_pines-1)/2 - i) * esp32_paso + esp32_offset_pines;
        color([0.10, 0.10, 0.10]) translate([px - 1.27, py - 1.27, T]) cube([2.54, 2.54, 2.5]);
        color(color_oro) translate([px - 0.32, py - 0.32, T]) cube([0.64, 0.64, 8.5]);

        if (mostrar_etiquetas) {
            v = col == 1 ? esp32_pines_der[i] : esp32_pines_izq[i];
            color(color_pin(col, i))
                translate([px - col*2.0, py, T + 0.01])
                rotate([0, 0, 180])
                linear_extrude(0.2)
                text(pin_txt(v), size = 1.2, halign = col == 1 ? "left" : "right", valign = "center", $fn = 8);
        }
    }
}

module esp32_en_caja() {
    translate([esp32_cx, esp32_cy, esp32_z_pcb]) rotate([0, 0, -90]) esp32_placa();
}

// Conector Dupont hembra puesto sobre un pin (banda del color de su señal + nombre del pin)
module dupont_en_pin(v, col) {
    p  = pin_world(v);
    z0 = esp32_z_pcb + esp32_espesor_pcb + 2.5;
    color([0.08, 0.08, 0.08]) translate([p[0] - 1.2, p[1] - 1.2, z0]) cube([2.4, 2.4, esp32_dupont_alto]);
    color(col) translate([p[0] - 1.21, p[1] - 1.21, z0 + esp32_dupont_alto - 2.5]) cube([2.42, 2.42, 2.5]);
    // Texto vertical sobre la cara frontal (-Y) del conector
    if (mostrar_etiquetas)
        color("white") translate([p[0] + 0.45, p[1] - 1.2, z0 + 0.8]) rotate([90, 0, 0]) linear_extrude(0.2)
            rotate([0, 0, 90]) text(pin_txt(v), size = 1.5, halign = "left", $fn = 8);
}

// --- Placa auxiliar: barras de red, pads y resistencias pull-up ---
module placa_auxiliar() {
    ztop = aux_z_base + aux_espesor;
    color([0.16, 0.42, 0.28])
    difference() {
        translate([aux_x0, aux_y_ad, aux_z_base]) cube([aux_x1 - aux_x0, aux_y_at - aux_y_ad, aux_espesor]);
        for (px = [aux_x0 + aux_inset, aux_x1 - aux_inset], py = [aux_y_ad + aux_inset, aux_y_at - aux_inset])
            translate([px, py, aux_z_base - eps]) cylinder(d = diam_tornillo_m3, h = aux_espesor + 2*eps, $fn = 24);
    }

    for (n = redes) {
        y  = lane_y(n);
        xa = aux_x_esp - 2;
        xb = max(pads_x(n)) + 2;
        color(color_red(n)) translate([xa, y - 1.1, ztop]) cube([xb - xa, 2.2, 0.4]);
        for (px = pads_x(n))
            color([0.85, 0.85, 0.88]) translate([px, y, ztop]) cylinder(d = 3, h = aux_z_pad - ztop, $fn = 24);
        if (mostrar_etiquetas)
            color("white") translate([aux_x0 + 1.2, y, ztop + 0.01]) linear_extrude(0.3)
                text(lane_txt(n), size = 1.6, valign = "center", $fn = 12);
    }

    // Encabezado de cada columna de sensor (borde trasero, zona libre de cables)
    if (mostrar_etiquetas)
        for (k = [0:3])
            color("white") translate([x_pasacable(k), aux_y_at - 3.2, ztop + 0.01]) linear_extrude(0.3)
                text(sensores_nombre[k], size = 1.6, halign = "center", $fn = 12);

    // Resistencias pull-up entre la barra de datos y 3V3
    for (r = resistencias) resistencia_axial(r[0], r[1], r[2]);
}

module banda_res(x, y, zc, yy, col) {
    color(col) translate([x, y + yy, zc]) rotate([-90, 0, 0]) cylinder(d = 2.5, h = 0.7, center = true, $fn = 20);
}

module resistencia_axial(red, valor, x) {
    ya = lane_y("3V3"); yb = lane_y(red);
    ym = (ya + yb)/2;
    zc = aux_z_pad + 2.2;
    lb = 6.3;
    color([0.85, 0.72, 0.50]) translate([x, ym, zc]) rotate([-90, 0, 0]) cylinder(d = 2.4, h = lb, center = true, $fn = 20);
    // Bandas: 4,7k = amarillo-violeta-rojo | 10k = marrón-negro-naranja
    c1 = valor == "4.7k" ? [1, 0.85, 0] : [0.45, 0.25, 0.08];
    c2 = valor == "4.7k" ? [0.55, 0.15, 0.7] : [0.05, 0.05, 0.05];
    c3 = valor == "4.7k" ? [0.9, 0.1, 0.1] : [1, 0.5, 0];
    banda_res(x, ym, zc, -2.0, c1);
    banda_res(x, ym, zc, -1.0, c2);
    banda_res(x, ym, zc,  0.0, c3);
    banda_res(x, ym, zc,  2.0, [0.8, 0.65, 0.2]);
    for (yp = [ya, yb]) {
        ye = yp < ym ? ym - lb/2 : ym + lb/2;
        tubo_ruta([[x, yp, aux_z_pad], [x, yp, zc], [x, ye, zc]], 0.6, color_acero, 6);
    }
    if (mostrar_etiquetas)
        color("white") translate([x + (red == "DHT" ? -1.9 : 4.2), ym, aux_z_base + aux_espesor + 0.01]) linear_extrude(0.3)
            rotate([0, 0, 90]) text(str("R ", valor), size = 1.5, halign = "center", $fn = 10);
}

// --- Cables del ESP32 a los pads de la placa auxiliar ---
module cables_esp32() {
    for (n = redes) {
        p   = pin_world(pin_esp_de_red(n));
        pad = [aux_x_esp, lane_y(n), aux_z_pad];
        tubo_bezier([[p[0], p[1], esp32_z_dupont], [p[0], p[1], esp32_z_dupont + 5],
                     [pad[0], pad[1], pad[2] + 14], pad], d_hilo, color_red(n), 18);
    }
}

// --- Conductores de cada sensor: desde el extremo de su funda hasta los pads ---
module cables_internos() {
    for (k = [0:3]) {
        nets = sensores_redes[k];
        m = len(nets);
        for (j = [0 : m-1]) {
            n   = nets[j];
            r   = rank_red(k, n);
            f   = arr_fin(m, r);
            P0  = [x_pasacable(k) + f[0], y_funda_in, z_pasacable + f[1]];
            pad = [pad_x(k, n), lane_y(n), aux_z_pad];
            tubo_bezier([P0, P0 + [0, 5, 0], [pad[0], pad[1], pad[2] + 5 + 2*r], pad], d_hilo, color_red(n), 16);
        }
    }
}

// Interior de la caja: ESP32, conectores, placa auxiliar y todo el cableado
module interior_electronico() {
    esp32_en_caja();
    for (n = redes) dupont_en_pin(pin_esp_de_red(n), color_red(n));
    placa_auxiliar();
    cables_esp32();
    cables_internos();
}

// --- DHT22 (cuerpo + 3 cables soldados a sus pines) en coordenadas del soporte ---
module dht22_electronica() {
    zc = dht22_z_cuerpo + dht22_s_espesor/2;
    yc = -dht22_alto_ext/2 + 1.5 + 0.5 + dht22_pin_largo + dht22_s_largo/2;   // pines apoyados junto a la ventana inferior
    y_tip = yc - dht22_s_largo/2 - dht22_pin_largo;
    S = S_local(0);

    color([0.93, 0.94, 0.96]) translate([-dht22_s_ancho/2, yc - dht22_s_largo/2, dht22_z_cuerpo]) cube([dht22_s_ancho, dht22_s_largo, dht22_s_espesor]);
    // rejilla frontal del sensor
    for (i = [-2:2])
        color([0.55, 0.57, 0.62]) translate([i*2.4 - 0.5, yc + 2, dht22_z_cuerpo + dht22_s_espesor - 0.2]) cube([1.0, 15, 0.3]);

    // 4 pines: 1=VCC, 2=DATA, 3=NC, 4=GND
    for (i = [0:3])
        color(color_oro) translate([(i - 1.5)*dht22_pin_paso - 0.3, y_tip, zc - 0.3]) cube([0.6, dht22_pin_largo + 0.5, 0.6]);

    pin_x = [-1.5*dht22_pin_paso, -0.5*dht22_pin_paso, 1.5*dht22_pin_paso];   // VCC, DATA, GND
    for (j = [0:2]) {
        n = sensores_redes[0][j];
        f = arr_fin(3, j);
        tip = [pin_x[j], y_tip, zc];
        fin = S + [f[0], 0, f[1]];
        color(color_acero) translate(tip) sphere(d = 1.6, $fn = 10);          // soldadura
        tubo_bezier([tip, tip + [0, -3, 0], fin + [0, 4, 0], fin], d_hilo, color_red(n), 12);
    }
}

// --- Sonda DS18B20: eje +Z, punta en z = 0, cable sale por el extremo +Z ---
module ds18b20_sonda() {
    color(color_acero) cylinder(d = diam_sonda_ds18b20, h = ds18b20_tubo_largo, $fn = 40);
    color([0.08, 0.08, 0.08]) translate([0, 0, ds18b20_tubo_largo])
        cylinder(d1 = ds18b20_boot_d, d2 = d_funda, h = ds18b20_boot_largo, $fn = 24);
}
module ds18b20_interior_electronica() {
    translate([0, 0, ds18b20_int_alto + 4 - ds18b20_tubo_largo]) ds18b20_sonda();
}
module ds18b20_exterior_electronica() {
    translate([0, ds18b20_ext_alto/2 - ds18b20_ext_capucha/2, ds_zc_ext()])
        rotate([-90, 0, 0]) translate([0, 0, -ds18b20_tubo_largo]) ds18b20_sonda();
}

// --- BH1750 (GY-302): PCB, chip y 4 cables soldados por debajo ---
module bh1750_electronica() {
    L = bh1750_pcb_largo; W = bh1750_pcb_ancho; T = bh1750_pcb_espesor;
    z0 = bh_z_pcb();
    S  = S_local(3);
    y_h = -W/2 + 1.6;

    color([0.45, 0.18, 0.58])
    translate([-L/2, -W/2, z0]) difference() {
        cube([L, W, T]);
        for (sx = [-1, 1]) translate([L/2 + sx*bh1750_dist_torn/2, W/2, -eps]) cylinder(d = bh1750_diam_torn, h = T + 2*eps, $fn = 20);
    }
    color([0.08, 0.08, 0.08]) translate([-1.6, 1.0, z0 + T]) cube([3.2, 3.0, 0.9]);          // ventana fotosensible (+Z)
    for (i = [0:4])   // pines VCC, GND, SCL, SDA, ADD (ADD sin conectar)
        color(color_oro) translate([(i-2)*2.54 - 0.32, y_h - 0.32, z0 - 2.0]) cube([0.64, 0.64, 2.0 + T]);

    for (j = [0:3]) {
        n = sensores_redes[3][j];
        f = arr_fin(4, j);
        tip = [(j-2)*2.54, y_h, z0 - 1.7];
        fin = S + [f[0], 0, f[1]];
        color(color_acero) translate(tip) sphere(d = 1.4, $fn = 10);
        tubo_bezier([tip, tip + [0, -3, 0], fin + [0, 3, 0], fin], d_hilo, color_red(n), 12);
    }
}

module soporte_sensor(k) {
    if (k == 0) soporte_dht22();
    else if (k == 1) soporte_ds18b20_interior();
    else if (k == 2) soporte_ds18b20_exterior();
    else soporte_bh1750();
}
module electronica_sensor(k) {
    if (k == 0) dht22_electronica();
    else if (k == 1) ds18b20_interior_electronica();
    else if (k == 2) ds18b20_exterior_electronica();
    else bh1750_electronica();
}

// ============================================================================
// 8. ETIQUETAS Y LEYENDAS
// ============================================================================
// Bandera vertical con texto, de cara al frente (-Y)
module bandera_etiqueta(pos, txt, ancho = 26) {
    translate(pos) {
        color([0.3, 0.3, 0.3]) cylinder(d = 0.8, h = 6, $fn = 8);
        color([0.97, 0.97, 0.90]) translate([-ancho/2, -0.6, 6]) cube([ancho, 1.2, 6]);
        color("black") translate([0, -0.6, 9]) rotate([90, 0, 0]) linear_extrude(0.4)
            text(txt, size = 2.3, halign = "center", valign = "center", $fn = 8);
    }
}

// Leyenda plana apoyada en el suelo: cada línea = [texto, color_muestra o undef]
module leyenda_plana(pos, lineas, ancho = 58, tam = 2.3) {
    h = len(lineas) * tam * 1.6 + 3;
    translate([pos[0], pos[1], 0]) {
        color([0.96, 0.96, 0.92]) translate([-ancho/2, -h/2, 0]) cube([ancho, h, 0.8]);
        for (i = [0 : len(lineas) - 1]) {
            yy = h/2 - 2.2 - (i + 1) * tam * 1.6 + tam * 0.9;
            sw = lineas[i][1];
            if (sw != undef) color(sw) translate([-ancho/2 + 2, yy - 0.1, 0.8]) cube([5, tam * 0.9, 0.4]);
            color("black") translate([-ancho/2 + (sw != undef ? 9 : 2), yy, 0.8]) linear_extrude(0.4)
                text(lineas[i][0], size = tam, $fn = 8);
        }
    }
}

function leyenda_sensor(k) =
    k == 0 ? [ ["DHT22 - T/HR interior", undef], ["3V3", c_3v3], [str("DATA > GPIO", gpio_dht22), c_dht], ["GND", c_gnd] ]
  : k == 1 ? [ ["DS18B20 - Temp INTERIOR", undef], ["3V3", c_3v3], [str("DATA > GPIO", gpio_ds18b20, " (bus)"), c_ds], ["GND", c_gnd] ]
  : k == 2 ? [ ["DS18B20 - Temp EXTERIOR", undef], ["3V3", c_3v3], [str("DATA > GPIO", gpio_ds18b20, " (bus)"), c_ds], ["GND", c_gnd] ]
  :          [ ["BH1750 - Luz (I2C)", undef], ["3V3", c_3v3], ["GND", c_gnd], [str("SDA > GPIO", gpio_sda), c_sda], [str("SCL > GPIO", gpio_scl), c_scl] ];

// ============================================================================
// 9. AUXILIAR: GUÍA DE CAMA ENDER-3 S1 (solo visual, nunca se exporta)
// ============================================================================
module guia_cama_ender3(ancho_cama = 220, largo_cama = 220) {
    if (mostrar_cama_ender3) {
        %translate([0, 0, -0.5]) cube([ancho_cama, largo_cama, 1.0], center=true);
    }
}

// ============================================================================
// 10. ENSAMBLES Y VISTAS
// ============================================================================
// Tapa en las vistas. "al_lado": apoyada en Z = 0 junto a la caja, tal como se imprime (placa abajo, labio arriba).
module tapa_en_vista(forzar = "") {
    est = forzar != "" ? forzar : estado_tapa;
    if (est == "al_lado")
        imprimible() translate([tapa_x_lado, 0, 0]) caja_control_tapa();
    else if (est == "cerrada")
        imprimible() translate([0, 0, caja_alto + espesor_tapa]) rotate([180, 0, 0]) caja_control_tapa();
}

// Soportes + sensores en su posición de la vista (y0 = posición Y del centro de los soportes)
module sensores_en_vista(y0) {
    for (k = [0:3])
        translate([sens_x[k], y0, 0]) rotate([0, 0, sens_rz[k]]) {
            imprimible() soporte_sensor(k);
            ilustrativo() electronica_sensor(k);
        }
}

module leyendas_sensores(y0) {
    if (mostrar_etiquetas && mostrar_electronica)
        for (k = [0:3]) leyenda_plana([sens_x[k], y0 - 34], leyenda_sensor(k));
}

// Cable corto que sale del sensor y termina en una bandera ("-> pasacable N")
module cables_cortos_sensores(y0) {
    for (k = [0:3]) {
        S = S_mundo(k, y0);
        d = D_mundo(k);
        T = [S[0], S[1] + largo_cable_corto + 10, 17];
        tubo_bezier([S, S + d*12, T - [0, 12, 0], T], d_funda, color_funda, 16, 12);
        if (mostrar_etiquetas) bandera_etiqueta(T + [0, 0, d_funda/2], str("-> cable ", k + 1), 22);
    }
}

// Cable desde cada sensor hasta su pasacable en la caja
module cables_a_caja(y0) {
    for (k = [0:3]) {
        S = S_mundo(k, y0);
        d = D_mundo(k);
        E = [x_pasacable(k), y_funda_in, z_pasacable];
        tubo_bezier([S, S + d*20, E - [0, 30, 0], E], d_funda, color_funda, 28, 12);
    }
}

// Tramo de cable que sobresale de la caja (modo "caja_ensamblada")
module cables_salida_caja() {
    for (k = [0:3]) {
        x  = x_pasacable(k);
        yo = -caja_ancho/2 - largo_cable_corto;
        tubo_ruta([[x, y_funda_in, z_pasacable], [x, yo, z_pasacable]], d_funda, color_funda, 12);
        if (mostrar_etiquetas)
            bandera_etiqueta([x, yo, z_pasacable + d_funda/2], sensores_nombre[k], 24);
    }
}

module verificar_gpio() {
    for (n = redes)
        if (pin_col(pin_esp_de_red(n)) == 0)
            echo(str("ADVERTENCIA: el pin ", pin_esp_de_red(n), " no esta en las filas de pines definidas del ESP32"));
}

// ---- Placas de impresión (Ender-3 S1: 220 x 220) ----
module placa_impresion_1() {
    y_caja = -110 + caja_ancho/2 + 3;
    y_fila = y_caja + caja_ancho/2 + 45;
    translate([0, y_caja, 0]) caja_control_base();
    translate([-45, y_fila, 0]) soporte_dht22();
    translate([ 45, y_fila, 0]) soporte_ds18b20_exterior();
}
module placa_impresion_2() {
    y_caja = -110 + caja_ancho/2 + 3;
    y_fila = y_caja + caja_ancho/2 + 45;
    translate([0, y_caja, 0]) caja_control_tapa();
    translate([-45, y_fila, 0]) soporte_ds18b20_interior();
    translate([ 45, y_fila, 0]) soporte_bh1750();
}

// ============================================================================
// EJECUCIÓN SEGÚN MODO SELECCIONADO
// ============================================================================
echo(str("MODO: ", modo_exportacion, exportable ? "  -> IMPRIMIBLE (apto para exportar STL)"
                                                 : "  -> VISUAL (contiene piezas ilustrativas: NO exportar a STL)"));

if (modo_exportacion == "caja_base")        { guia_cama_ender3(); caja_control_base(); }
else if (modo_exportacion == "caja_tapa")   { guia_cama_ender3(); caja_control_tapa(); }
else if (modo_exportacion == "dht22")       { guia_cama_ender3(); soporte_dht22(); }
else if (modo_exportacion == "ds18b20_int") { guia_cama_ender3(); soporte_ds18b20_interior(); }
else if (modo_exportacion == "ds18b20_ext") { guia_cama_ender3(); soporte_ds18b20_exterior(); }
else if (modo_exportacion == "bh1750")      { guia_cama_ender3(); soporte_bh1750(); }
else if (modo_exportacion == "kit_placa_1") { guia_cama_ender3(); placa_impresion_1(); }
else if (modo_exportacion == "kit_placa_2") { guia_cama_ender3(); placa_impresion_2(); }
else if (modo_exportacion == "kit_impresion") {
    guia_cama_ender3();                       placa_impresion_1();
    translate([240, 0, 0]) { guia_cama_ender3(); placa_impresion_2(); }
}
else if (modo_exportacion == "lote_soportes") {
    guia_cama_ender3();
    translate([-45,  30, 0]) soporte_dht22();
    translate([ 35,  30, 0]) soporte_ds18b20_exterior();
    translate([-45, -35, 0]) soporte_ds18b20_interior();
    translate([ 35, -35, 0]) soporte_bh1750();
}
else if (modo_exportacion == "ensamble_caja") {
    guia_cama_ender3();
    difference() {
        union() {
            caja_control_base();
            translate([0, 0, caja_alto + espesor_tapa]) rotate([180, 0, 0]) caja_control_tapa();
        }
        if (corte_seccion_caja)
            translate([0, -caja_ancho/2, caja_alto/2]) cube([caja_largo + 40, caja_ancho, caja_alto + 30], center=true);
    }
}
else if (modo_exportacion == "vista_general") {
    desplazamiento_x_tapa = caja_largo + 16 + separacion_piezas;
    fila_sensores_y       = -(caja_ancho/2 + 30 + separacion_piezas);
    translate([-desplazamiento_x_tapa/2, 25, 0]) caja_control_base();
    translate([ desplazamiento_x_tapa/2, 25, 0]) caja_control_tapa();
    translate([-120, fila_sensores_y, 0]) soporte_dht22();
    translate([ -40, fila_sensores_y, 0]) soporte_ds18b20_interior();
    translate([  40, fila_sensores_y, 0]) soporte_ds18b20_exterior();
    translate([ 120, fila_sensores_y, 0]) soporte_bh1750();
}
// ---------------- MODOS VISUALES ----------------
else if (modo_exportacion == "vista_sensores") {
    verificar_gpio();
    sensores_en_vista(0);
    ilustrativo() cables_cortos_sensores(0);
    leyendas_sensores(0);
}
else if (modo_exportacion == "caja_ensamblada") {
    verificar_gpio();
    imprimible() caja_control_base();
    ilustrativo() { interior_electronico(); cables_salida_caja(); }
    tapa_en_vista();
}
else if (modo_exportacion == "caja_cerrada") {
    imprimible() caja_control_base();
    ilustrativo() { interior_electronico(); cables_salida_caja(); }
    tapa_en_vista("cerrada");
}
else if (modo_exportacion == "ensamblaje_completo") {
    verificar_gpio();
    y0 = -caja_ancho/2 - sensores_dist_y;
    imprimible() caja_control_base();
    ilustrativo() { interior_electronico(); cables_a_caja(y0); }
    tapa_en_vista();
    sensores_en_vista(y0);
    leyendas_sensores(y0);
}
else {
    echo(str("MODO DESCONOCIDO: ", modo_exportacion));
}
