{-| Modulo      : Laberinto

    Descripcion : Constructores y funciones de acceso para 
                  el tipo de dato abstracto Laberinto. 

    Autores     : Francisco Marquez 12-11163@usb.ve
                  Daniel Francis 12-10863@usb.ve
 -}
module Laberinto where

import Data.Maybe(fromJust, isJust, isNothing)
import Data.List(tail)

-- * Tipos de dato o clases

-- ** Laberinto
-- | Tipo de dato laberinto, con una trifurcacion
data Laberinto = Lab Trifurcacion (Maybe Tesoro) deriving (Eq, Read,Show)

-- ** Trifurcacion
-- | Una trifurcacion que dirije a hasta tres laberintos
data Trifurcacion = Tri (Maybe Laberinto) (Maybe Laberinto) (Maybe Laberinto) deriving (Eq, Read,Show)
 
-- ** Tesoro
-- | Un tesoro. Puede ser pasado por alto para seguir otro laberinto adyacente
data Tesoro = Tes String (Maybe Laberinto) deriving(Eq, Read,Show)

-- * Funciones de Construccion

-- ** sinSalida
-- | Trifurcacion sin salida
sinSalida :: Trifurcacion
sinSalida = Tri Nothing Nothing Nothing

-- ** laberintoNuevo
-- | Laberinto sin salida
laberintoNuevo :: Laberinto
laberintoNuevo = Lab sinSalida Nothing

-- ** pasarPorAlto
-- | Dado un laberinto y una descripcion, retorna un tesoro 
pasarPorAlto :: String -> Maybe Laberinto -> Tesoro
pasarPorAlto str lab = Tes str lab

-- ** pasarPorAlto'
-- | Retorna el laberinto que sigue despues del tesoro
pasarPorAlto' :: Tesoro -> Laberinto
pasarPorAlto' (Tes str lab) = fromJust lab

-- ** relacionaCamino
-- | Relaciona tomar una direccion en una trifurcacion que llega a un laberinto
relacionaCamino :: Trifurcacion -> Laberinto -> Char -> Trifurcacion
relacionaCamino (Tri i r d) lab str = 
  case str of 'i' -> Tri (Just lab) r d
              'r' -> Tri i (Just lab) d
              'd' -> Tri i r (Just lab)

-- * Funciones de acceso

-- ** seguirRuta
-- | Sigue recursivamente una ruta de la forma "ridir" dentro de un laberinto para
--   llegar a otro. Tome "i " como izquierda, "r" como recto y "d" como derecha
seguirRuta:: Laberinto -> String -> Laberinto
seguirRuta (Lab (Tri i r d) tes) str = 
  if str == []
    then (Lab (Tri i r d) tes)
  else
    case (head str) of 'i' -> seguirRuta (izquierda (Lab (Tri i r d) tes)) (tail str)
                       'r' -> seguirRuta (recto (Lab (Tri i r d) tes)) (tail str)
                       'd' -> seguirRuta (derecha (Lab (Tri i r d) tes)) (tail str)

-- ** izquierda
-- | Retorna el laberinto que queda al entrar 
--   por la izquierda a la trifurcacion
izquierda :: Laberinto -> Laberinto
izquierda (Lab (Tri i r d) tes) = if isNothing i then (Lab (Tri i r d) tes) else fromJust i

-- ** recto
-- | Retorna el laberinto que queda al entrar 
--   por el medio a la trifurcacion
recto :: Laberinto -> Laberinto
recto (Lab (Tri i r d) tes) = if isNothing r then (Lab (Tri i r d) tes) else fromJust r

-- ** derecha
-- | Retorna el laberinto que queda al entrar 
--   por la derecha a la trifurcacion
derecha :: Laberinto -> Laberinto
derecha (Lab (Tri i r d) tes) = if isNothing d then (Lab (Tri i r d) tes) else fromJust d