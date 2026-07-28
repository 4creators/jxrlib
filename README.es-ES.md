# jxrlib
### Formato JPEG XR
JPEG XR es un formato de imagen fija basado en tecnología desarrollada originalmente por Microsoft bajo el nombre de HD Photo (anteriormente Windows Media™ Photo). El formato JPEG XR es similar, pero no idéntico, al formato HD Photo/Windows Media™ Photo.

El formato JPEG XR reemplaza al formato HD Photo/Windows Media™ Photo tanto en Windows 8 como en el Windows Image Component (WIC). WIC acompaña a los paquetes redistribuibles de Internet Explorer 10 para versiones anteriores de Windows. Algunas convenciones de nomenclatura de “Windows Media™ Photo” (WMP) todavía se utilizan internamente en esta versión del DPK.

Los archivos JPEG XR utilizan la extensión .jxr. Las aplicaciones que admitan el formato de archivo JPEG XR deben reconocer y decodificar los archivos .hdp/.wdp de HD Photo/Windows Media™ Photo, pero solo deben ofrecer la creación de archivos con la extensión .jxr.

### Especificación de Codificación de Imágenes JPEG XR
La Especificación de Codificación de Imágenes JPEG XR proporciona una especificación detallada de los algoritmos del codificador y decodificador de compresión, además de la estructura detallada del flujo de bits (elemental) de los datos comprimidos. Este documento está diseñado para ser utilizado en conjunto con el código fuente incluido. Si encuentra casos en los que el código difiera de la documentación, se debe utilizar la implementación del código como referencia.

La Especificación de Codificación de Imágenes JPEG XR es un estándar internacional y está disponible en: http://www.itu.int/rec/T-REC-T.832 mientras que el software de referencia está disponible en: http://www.itu.int/rec/T-REC-T.835.

### Estado de la implementación de JPEG XR
"JPEGXR_DPK_1.0.doc" documenta el contenido de este kit de portabilidad, el uso de las utilidades de conversión de archivos por línea de comandos (JXREncApp.exe y JXRDecApp.exe), y los detalles técnicos de las API y estructuras de datos entre estas aplicaciones de muestra de línea de comandos y el códec central.

El código y la documentación de este lanzamiento representan el diseño y la especificación final del flujo de bits 1.0, y pueden utilizarse como referencia para las implementaciones finales de codificadores y decodificadores para JPEG XR.

Este lanzamiento del DPK ha sido sometido a exhaustivas pruebas de todos los diversos formatos de píxeles, opciones del codificador y modos de operación. Confiamos en que la mayoría de los errores y otros fallos hayan sido resueltos. Cualquier error de código, error de documentación u otras discrepancias encontradas en este candidato a lanzamiento deben informarse a Microsoft lo antes posible. Estos pueden enviarse a hdview@microsoft.com.

Este DPK proporciona soporte básico para arquitecturas big endian. Hemos probado con éxito el codificador y el decodificador utilizando un procesador big endian. Este soporte se proporciona como una referencia inicial para ser adaptada a la plataforma y arquitectura de hardware específica del sistema de destino.

### Información de Contacto
Para cualquier pregunta técnica o comentarios sobre cualquier parte de este Device Porting Kit, incluida la documentación, envíe un correo electrónico a:

  hdview@microsoft.com

Responderemos lo más pronto posible a sus preguntas.

Información adicional, mejores prácticas, herramientas, utilidades, código de muestra, contenido de imágenes de muestra, enlaces a recursos adicionales y discusiones comunitarias se pueden encontrar actualmente en http://hdview.wordpress.com/.

#### El Equipo de Desarrollo de Microsoft JPEG XR
### Enlaces interesantes
[JPEG XR Updates](https://hdview.wordpress.com/2013/05/30/jpegxr-updates/)

[JPEG XR Photoshop Plugin and Source Code](https://hdview.wordpress.com/2013/04/11/jpegxr-photoshop-plugin-and-source-code/)
