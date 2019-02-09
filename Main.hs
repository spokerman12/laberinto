{-| Modulo      : Main

    Descripcion : Método principal del programa
                  

    Autores     : Francisco Marquez 12-11163@usb.ve
                  Daniel Francis 12-10863@usb.ve
 -}


module Main where

import System.IO(writeFile, readFile)
import System.Exit(exitWith, ExitCode(ExitSuccess))
import Data.Typeable(Typeable, typeOf)
import Data.Maybe(fromJust, isJust, isNothing)
import Laberinto
import Sabio
import Herramientas

-- ** main
-- | Funcion principal. Explica las reglas del juego.
main :: IO b
main = do
  clear
  putStrLn "Bienvenido joven viajero."
  putStrLn "Este es el laberinto Universidad Simón Bolívar."
  putStrLn "Al final de él se encuentran los Estudiantes que fueron capaces de graduarse en la USB."
  putStrLn "Si quieren pasar, hay ciertas normas que deben conocer."
  putStrLn "- No puedes retroceder."
  putStrLn "- Una vez dentro del laberinto solo puedes seguir hacia adelante, en linea recta (\"r\") o girando a tu izquierda (\"i\") o derecha (\"d\")."
  putStrLn "- El recorrido termina cuando encuentres una pasantía o un trabajo de grado."
  opciones laberintoNuevo