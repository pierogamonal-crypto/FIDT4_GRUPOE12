# 🌱 Equipo 12 — Fundamentos de Diseño

## Invernadero Inteligente: sistema IoT para protección de cultivos frente a bajas temperaturas

**Curso:** Fundamentos de Diseño 2026-II  
**Equipo:** 12  
**Áreas:** Ingeniería Ambiental / Ingeniería Informática / Ingeniería Industrial  
**Institución:** Universidad Peruana Cayetano Heredia

---

## 1. Descripción del equipo

Somos el **Equipo 12** del curso **Fundamentos de Diseño**. Nuestro proyecto se orienta al desarrollo de una solución tecnológica de pequeña escala para apoyar la protección de cultivos frente a condiciones ambientales desfavorables.

Nuestra propuesta parte de una problemática agrícola presente en zonas altoandinas del Perú: las bajas temperaturas y las heladas pueden afectar las condiciones necesarias para el desarrollo de los cultivos. Frente a ello, planteamos un **invernadero inteligente a escala**, capaz de monitorear variables ambientales y del suelo y activar automáticamente mecanismos de protección y riego.

El proyecto integra diseño físico, electrónica, automatización, IoT y visualización de datos en una sola solución.

---

## 2. Problemática

### 2.1 Delimitación de la problemática

En determinadas zonas altoandinas del Perú, los cultivos pueden estar expuestos a **bajas temperaturas y heladas**, condiciones que pueden alterar el ambiente necesario para su desarrollo.

Una dificultad adicional es que el control de las condiciones del cultivo puede depender de la supervisión manual. Cuando una condición ambiental cambia rápidamente, una respuesta tardía puede disminuir la capacidad de proteger el cultivo o utilizar adecuadamente los recursos disponibles.

A partir de esta problemática, nuestro equipo plantea la siguiente pregunta de diseño:

> **¿Cómo podemos diseñar un sistema de invernadero de bajo costo que detecte condiciones ambientales de riesgo y active oportunamente mecanismos de protección y riego para mantener condiciones adecuadas para un cultivo a pequeña escala?**

### 2.2 Problemas específicos abordados

- Descenso de temperatura dentro del espacio de cultivo.
- Humedad insuficiente del suelo.
- Necesidad de supervisar variables ambientales de manera continua.
- Necesidad de automatizar determinadas acciones del invernadero.
- Uso eficiente del agua disponible para riego.

---

## 3. ODS relacionados

### ODS 2 — Hambre Cero

El proyecto puede contribuir indirectamente a este objetivo al apoyar la producción y protección de cultivos mediante mejores condiciones de manejo a pequeña escala.

### ODS 6 — Agua Limpia y Saneamiento

El sistema contempla el monitoreo de la disponibilidad de agua y la automatización del riego, buscando utilizar el recurso de manera más controlada.

### ODS 9 — Industria, Innovación e Infraestructura

El proyecto incorpora sensores, microcontroladores, automatización, diseño mecánico y conectividad IoT en una infraestructura agrícola de pequeña escala.

### ODS 11 — Ciudades y Comunidades Sostenibles

El enfoque puede vincularse con soluciones de producción de alimentos a pequeña escala cuando el invernadero se adapte a contextos urbanos o periurbanos.

### ODS 13 — Acción por el Clima

El proyecto aborda una condición climática que afecta la producción agrícola y plantea una estrategia tecnológica de adaptación mediante protección del cultivo y monitoreo ambiental.

---

## 4. Propuesta de solución

### 🌱 Invernadero Inteligente

La propuesta consiste en construir un **invernadero tipo capilla a escala**, equipado con sensores conectados a un **ESP32**.

El sistema monitoreará:

- Temperatura del aire.
- Humedad ambiental.
- Temperatura próxima al cultivo.
- Humedad del suelo.
- Luminosidad.
- Nivel de agua del tanque.

De acuerdo con las condiciones detectadas, el sistema podrá activar automáticamente:

- Un sistema de calefacción cuando la temperatura llegue a un nivel de riesgo definido para el prototipo.
- Una bomba de agua y una electroválvula cuando el suelo presente humedad insuficiente.

Los datos y estados del sistema podrán visualizarse mediante un **dashboard web o aplicación**.

---

   
## 📸 Fotografía del Equipo  

---  <img width="1600" height="1200" alt="WhatsApp Image 2026-08-20 at 12 39 26 PM" src="https://github.com/user-attachments/assets/7dd2dc37-73cd-448a-a1fa-2bfd0c125bf1" />


## 👥 Integrantes del Equipo  

| Foto | Nombre | Rol | Intereses |
|------|--------|-----|-----------|
| <img width="90" height="90" alt="image" src="https://github.com/user-attachments/assets/a769fb77-1360-47f0-8adf-1f29caf976d9" /> | **Gamonal Castro Piero Alexander** | Líder del equipo | Innovación social, Tecnología IoT|
| <img width="90" height="90" alt="image" src="https://github.com/user-attachments/assets/62074141-4693-4923-8801-7d6de69c9fcf"> | **Josue Obed Barzola Reategui** | Responsable de investigación | Gestión ambiental, desarrollo comunitario |
| <img width="90" height="90" alt="image" src="https://github.com/user-attachments/assets/e2899872-e7ef-4ace-a04b-82cc0d1e6e06"> | **Marx Uscamayta Lazaro** | Diseñador/a | Diseño de prototipos, creatividad aplicada |
| <img width="90" height="90" alt="image" src="https://github.com/user-attachments/assets/9ddd682e-0597-45f3-acbd-7ad4457f3cb5"> | **Felipe Gabriel Loarte Nathals** | Encargado de documentación | Comunicación científica, redacción técnica |
| <img src="/Recursos/Imágenes/IMG_6764.jpeg" width="90"/> | **Angel Galarza Vivanco** | Programador/a - Modelador/a | Programación, análisis de datos, simulación |

---

## 4. Delimitación de la Problemática

Como equipo, centraremos nuestro trabajo en el **desperdicio de alimentos en el Perú**, considerando especialmente las situaciones que se presentan durante la comercialización y el consumo de alimentos y que contribuyen a que productos potencialmente aprovechables terminen siendo desechados.

### Contexto del Problema

Desde septiembre de 2015, el Perú se sumó a la aprobación del documento **“Transformar nuestro mundo: la Agenda 2030 para el Desarrollo Sostenible”** de la Organización de las Naciones Unidas (ONU), un plan global que estableció 17 Objetivos de Desarrollo Sostenible (ODS) orientados a erradicar la pobreza, proteger el planeta y garantizar la paz y la prosperidad.

A casi 11 años de su aprobación, el desempeño del Perú continúa presentando importantes desafíos. El informe 2025 del **Sustainable Development Solutions Network (SDSN)** (Sachs et al., 2025), adscrito a la ONU, ubica al Perú en el puesto 65 de 167 países, con un índice de 72,7 sobre 100.

Estos resultados evidencian que, si bien existen avances en determinados ámbitos, aún persisten brechas que requieren mayor atención para alcanzar los objetivos establecidos para 2030.

Dentro de este contexto, nuestro equipo se enfoca en el **ODS 12: Producción y Consumo Responsables**, que comprende diversas problemáticas relacionadas con la generación y gestión inadecuada de residuos, el bajo nivel de reciclaje, el desperdicio de alimentos, el consumo excesivo de productos y la contaminación asociada a los actuales patrones de producción y consumo (United Nations Department of Economic and Social Affairs, s. f.).

### Desperdicio de Alimentos en el Perú

A partir de las problemáticas comprendidas dentro del ODS 12, el equipo ha seleccionado como tema de interés el **desperdicio de alimentos**, debido a su impacto ambiental, económico y social.

En el Perú, más de **12 millones de toneladas de alimentos se pierden a lo largo de la cadena productiva**, cifra que representa casi la mitad del suministro total de alimentos del país. Esta problemática se presenta desde las etapas de producción hasta el consumidor final y evidencia la existencia de importantes ineficiencias en el aprovechamiento de los alimentos disponibles (FAO, 2024).

Asimismo, la FAO señala que, específicamente en la etapa de venta al detalle, en el Perú se desperdician aproximadamente **3 076 millones de calorías**, cantidad que podría satisfacer las necesidades nutricionales de cerca de **2 millones de personas**.

### Caso del Gran Mercado Mayorista de Lima

La problemática también puede observarse en espacios concretos de comercialización de alimentos. Por ejemplo, en el **Gran Mercado Mayorista de Lima** se descartan diariamente entre **40 y 60 toneladas de alimentos**, dependiendo de la temporada.

Esta situación evidencia que una cantidad considerable de productos alimenticios termina siendo desechada durante su comercialización, a pesar de que parte de estos alimentos todavía podría ser aprovechada (Vite, 2021).

### Consecuencias de la Problemática

El desperdicio de alimentos representa un desaprovechamiento de los recursos empleados en su **producción, transporte y comercialización**. Además, genera impactos ambientales y sociales relacionados con la utilización innecesaria de recursos y la generación de residuos.

En este contexto, el desperdicio de alimentos constituye un desafío relevante para el cumplimiento del **ODS 12**, particularmente en relación con la reducción de las pérdidas y desperdicios de alimentos y la promoción de patrones de consumo responsables.

Si bien se han registrado avances en materia normativa, empresarial y en determinadas iniciativas de valorización, todavía persisten dificultades relacionadas con la prevención, reducción, reutilización y adecuada gestión de los residuos y alimentos descartados.

### Enfoque del Equipo durante el Curso

Durante el desarrollo del curso, el equipo analizará **cómo y por qué se produce el desperdicio de alimentos en contextos específicos**, identificando las principales causas, los actores involucrados, los usuarios afectados y las necesidades relacionadas con esta problemática.

Nuestro enfoque estará orientado a comprender las condiciones que favorecen el desperdicio de alimentos y explorar oportunidades de diseño que permitan posteriormente plantear una solución innovadora, viable y relacionada con el **ODS 12: Producción y Consumo Responsables**.

---

## 📌 Resumen Final

Este README presenta al **Equipo 12**, el **ODS 12: Producción y Consumo Responsables** como eje principal de nuestro trabajo y la problemática del **desperdicio de alimentos** como tema de interés.

A lo largo del curso, analizaremos las causas, consecuencias, usuarios afectados y oportunidades relacionadas con esta problemática, con el objetivo de aplicar la metodología de diseño para desarrollar una propuesta que contribuya a promover patrones de consumo más responsables y sostenibles.

Bibliografia:

1. United Nations. (2015). Transforming our world: The 2030 Agenda for Sustainable Development. https://sdgs.un.org/2030agenda.
2. Sachs, J. D., Lafortune, G., Fuller, G., & Iablonovski, G. (2025). SUSTAINABLE DEVELOPMENT REPORT 2025 Financing Sustainable Development to 2030 and Mid-Century. Dublin University Press. https://doi.org/10.25546/111909.
3. Ministerio del Ambiente. (2025, 19 de septiembre). Perú: valorización de residuos en 2024 superó las 249 000 toneladas. Gob.pe. https://www.gob.pe/institucion/minam/noticias/1248744-peru-valorizacion-de-residuos-en-2024-supero-las-249-000-toneladas.
4. Organización de las Naciones Unidas para la Alimentación y la Agricultura (FAO). (2024, 10 de noviembre). Más de 12 millones de toneladas de alimentos se pierden a lo largo de la cadena productiva en el Perú. FAO Perú. https://www.fao.org/peru/noticias/detail/M%C3%81S-DE-12-MILLONES-DE-TONELADAS-DE-ALIMENTOS-SE-PIERDEN-A-LO-LARGO-DE-LA-CADENA-PRODUCTIVA-EN-EL-PER%C3%9A-/es?utm_source=chatgpt.com
5. Vite, A. (2021, 12 de diciembre). Todo sobre la pérdida de alimentos. Diario Oficial El Peruano. https://elperuano.pe/noticia/135214-todo-sobre-la-perdida-de-alimentos?utm_source=chatgpt.com
   



