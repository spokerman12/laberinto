# Laberinto

Instrucciones:
1. Extraer los contenidos del archivo comprimido que contiene a este Readme
2. Ubicándose en el directorio donde extrajo los archivos, ejecute "make" en la terminal del sistema para Linux y Mac o use cygwin/nmake si usa Windows
2.5 Se generarán los archivos necesarios para correr el programa. La documentación estará la carpeta "Documentación" en los archivos Sabio.html, Laberinto.html, Herramientas.html y Main.html.
3. Ejecute en la terminal "/.El_Sabio_del_Laberinto" o su equivalente en Windows para correr un archivo ejecutable.


Cada laberinto se compone de trifurcaciones, es decir, divisiones de la vía en tres en las que se puede
• Voltear a la izquierda
• Voltear a la derecha
• Seguir recto
El usuario no puede especificar ninguna otra opción (por ejemplo, no puede dar media vuelta para
devolverse por donde vino) ya que el sabio no presta atención a viajeros que tratan de pasarse de listos.
Si una división carece de una de las opciones (por ejemplo, en una intersección en T no se puede seguir
recto) y el usuario especifica esa opción faltante, el sabio pone ojos en blanco e ignora este paso del
recorrido. Si el recorrido lo llevaría a un camino sin salida y el recorrido tiene aún más pasos, el sabio se
ríe para sus adentros, perimitiendo que el visitante siga indicando su recorrido planeado pero sin prestarle
atención ya que no tendría por dónde seguir. Si hay una división que regresaría al viajero a un punto ya
visitado, el sabio lo ignora, ya que prefiere concebir los laberintos en términos clásicos.
El sabio siempre permite que los visitantes den todo su recorrido antes de responder, y si no los conduce
hasta un tesoro o un camino sin salida, permite que den una lista de pasos adicionales.
El sabio distingue entre los diferentes tesoros. Si el recorrido pasa sobre un tesoro pero no termina en él,
el sabio supone que el tesoro será ignorado por los viajeros.