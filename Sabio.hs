{-| Modulo      : Sabio

    Descripcion : Cliente para manejo del laberinto
                  

    Autores     : Francisco Marquez 12-11163@usb.ve
                  Daniel Francis 12-10863@usb.ve
 -}

module Sabio where

import System.IO(writeFile, readFile)
import System.Exit(exitWith, ExitCode(ExitSuccess))
import Data.Typeable(Typeable, typeOf)
import Data.Maybe(fromJust, isJust, isNothing)
import Laberinto
import Herramientas

-- import System.Console.ANSI(clearScreen)

-- * Funciones principales del cliente

-- ** opciones
-- | Muestra las opciones disponibles
opciones :: Laberinto -> IO b
opciones lab = do
  putStrLn "¿Qué deseas hacer?"
  putStrLn "  - Ingresa 1 para Comenzar a hablar de un laberinto nuevo."
  putStrLn "  - Ingresa 2 para Ingresar una ruta."
  putStrLn "  - Ingresa 3 para Reportar una pared abierta."
  putStrLn "  - Ingresa 4 para Reportar un derrumbe."
  putStrLn "  - Ingresa 5 para Reportar un tesoro tomado."
  putStrLn "  - Ingresa 6 para Reportar un tesoro hallado."
  putStrLn "  - Ingresa 7 para Dar nombre al laberinto actual."
  putStrLn "  - Ingresa 8 para Hablar de un laberinto de nombre conocido."
  putStrLn "  - Ingresa 0 para salir."
  opc <- getLine

  if elem opc ["0","1","2","3","4","5","6","7","8"] then
    seleccion opc lab
  else do
    clear
    putStrLn "*** Error: Opción no valida"
    opciones lab

-- ** seleccion
-- | Ejecuta la opcion resultante de 'opciones'
seleccion :: [Char] -> Laberinto -> IO b
seleccion opc lab = 
  case opc of "0" -> opcion0
              "1" -> opcion1
              "2" -> opcion2 lab
              "3" -> opcion3 lab
              "4" -> opcion4 lab
              -- "5" -> opcion5 lab
              -- "6" -> opcion6 lab
              "7" -> opcion7 lab
              "8" -> opcion8

-- * Opciones del menú principal

-- ** opcion0
-- | Salir del programa
opcion0 :: IO a
opcion0 = exitWith ExitSuccess

-- ** opcion1
-- | Comenzar a hablar de un laberinto nuevo
opcion1 :: IO b
opcion1 = do 
  putStrLn "¿Cuál es la ruta inicial?"
  ruta <- getLine
  if (rutaValida ruta)
    then do
      putStrLn "Listo."
      opciones (poblarLaberinto laberintoNuevo ruta)
  else do
    putStrLn "Debe haber un error..."
    opcion1

-- ** opcion2
-- | Preguntar ruta
opcion2:: Laberinto -> IO b
opcion2 lab = do
  putStrLn "¿A dónde vamos? Si escribes 0 vuelves al menu"
  ruta <- getLine
  if ruta == "0" then opciones lab
    else
      if not (rutaValida ruta)
        then do
          putStrLn "Debe haber un error..."
          opcion2 lab
      else do
        putStrLn "Ok."

      -- La ruta no es correcta o es vacia
        if (seguirRuta lab ruta) == lab
          then do
            putStrLn "Esa ruta no lleva a ningun sitio."
            putStrLn "Prueba otra vez."
            opcion2 lab

      -- La ruta lleva a un camino sin salida
        else if (trifurcacionLocal $ seguirRuta lab ruta) == sinSalida
          then do
            putStrLn "Desde donde estamos, no hay salida."
            if isNothing (tesoroLocal $ seguirRuta lab ruta)
              then do
                putStrLn "No hay tesoros..."
                opciones $ seguirRuta lab ruta
            else do
                putStrLn ("Encontraste: "++ show (fromJust (tesoroLocal $ seguirRuta lab ruta)))
                opciones $ seguirRuta lab ruta

      -- El recorrido puede continuar (hay caminos abiertos)
        else do
          if isNothing (tesoroLocal $ seguirRuta lab ruta)
            then do
              putStrLn "No hay tesoros..."
              putStrLn "Podrías seguir explorando este laberinto."
              putStrLn "  - Si escribes 0 seguiremos tu ruta desde este punto."
              putStrLn "  - Si escribes 1 seguiremos tu ruta desde el principio de este laberinto."
              putStrLn "  - Si escribes otra cosa volvemos al menu principal, mismo laberinto."
              respuesta <- getLine
              if respuesta == "0"
                then opcion2 $ seguirRuta lab ruta
              else if respuesta == "1"
                then opcion2 lab
              else opciones lab

          else do
              putStrLn ("Encontraste: "++ show (fromJust (tesoroLocal $ seguirRuta lab ruta)))
              putStrLn "Podrías seguir explorando este laberinto."
              putStrLn "  - Si escribes 0 seguiremos tu ruta desde este punto."
              putStrLn "  - Si escribes 1 seguiremos tu ruta desde el principio de este laberinto."
              putStrLn "  - Si escribes otra cosa volvemos al menu principal, mismo laberinto."
              respuesta <- getLine
              if respuesta == "0"
                then opcion2 $ seguirRuta lab ruta
              else if respuesta == "1"
                then opcion2 lab
              else opciones lab

-- ** opcion3
-- | Reportar pared abierta. 
--   Se recibe un camino, se recorre el camino 
--   hasta alcanzar una pared (un Nothing). 
--   La ruta dada a partir de ese momento se convierte 
--   en el laberinto alcanzable por esa dirección.
opcion3 :: Laberinto -> IO b
opcion3 lab = do
  putStrLn "La ruta que propongas se hará realidad en el laberinto actual."
  ruta <- getLine
  if (rutaValida ruta)
    then do
      putStrLn "Listo."
      opciones (paredAbierta lab ruta)
  else do
    putStrLn "Debe haber un error..."
    opcion3 lab

-- ** opcion4
-- | Reportar derrumbe. Se sigue la ruta en el laberinto y se elimina
--   el laberinto correspondientea la dirección dada en ese sitio. 
opcion4 :: Laberinto -> IO b
opcion4 lab = do
  putStrLn "¿Dónde ocurrió el derrumbe?"
  ruta <- getLine
  if (rutaValida ruta)
    then do
      putStrLn "¿En cuál dirección?"
      direccion <- getLine
      if rutaValida direccion
        then do
          putStrLn "Ok."
          opciones (derrumbeLaberinto lab ruta (head direccion))
      else do
        putStrLn "Esa dirección no es correcta."
        opcion4 lab
  else do
    putStrLn "Debe haber un error..."
    opcion4 lab  


-- -- ** opcion5
-- -- | Reportar tesoro tomado al final de la ruta dada
-- opcion5 :: Laberinto -> IO b
-- opcion5 lab = do
--   putStrLn "¿Dónde dejó de estar el tesoro?"
--   ruta <- getLine
--   if (rutaValida ruta)
--     then do
--       putStrLn "Listo."
--       opcion5 lab
--   else do
--     putStrLn "Debe haber un error..."
--     opcion5 lab

-- ** opcion6
-- | Reportar tesoro hallado al final de la ruta dada
-- opcion6 lab = do 
--   putStrLn "¿Dónde está el tesoro?"
--   ruta <- getLine
--   if (rutaValida ruta)

-- ** opcion7
-- | Dar nombre al laberinto (Guarda el laberinto como archivo de texto simple)
opcion7 :: Laberinto -> IO b
opcion7 lab = do
  putStrLn "¿Qué nombre deseas colocarle al laberinto?"
  nombre <- getLine
  writeFile nombre (show lab)
  putStrLn "Listo."
  opciones lab

-- ** opcion8
-- | Hablar de un laberinto de nombre conocido (Carga un laberinto a partir de
--   un archivo de texto simple, siguiendo el formato impuesto por la opcion7)
opcion8 :: IO b
opcion8 = do
  putStrLn "¿De qué laberinto deseas hablar?"
  nombre <- getLine
  lab <- readFile nombre
  putStrLn "Listo."
  opciones (read lab :: Laberinto)