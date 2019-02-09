{-| Modulo      : Herramientas

    Descripcion : Funciones adicionales para 
                  manipular el laberinto y las funciones del sabio

    Autores     : Francisco Marquez 12-11163@usb.ve
                  Daniel Francis 12-10863@usb.ve
 -}

module Herramientas where

import Laberinto
import Data.Maybe(fromJust, isJust, isNothing)

-- * Funciones de construcción

-- ** poblarLaberinto
-- | Toma un laberinto y le construye una ruta explorable.
poblarLaberinto :: Laberinto -> String -> Laberinto
poblarLaberinto (Lab tri tes) str
    | str == "" = (Lab tri tes)
    | otherwise = Lab (relacionaCamino tri (poblarLaberinto laberintoNuevo (tail str)) (head str)) tes

-- ** paredAbierta
-- |  Abre una pared (dirección a Nothing) en el laberinto a partir del resto de un camino dado
paredAbierta :: Laberinto -> String -> Laberinto
paredAbierta (Lab (Tri i r d) tes) str =
    if str == []
        then (Lab (Tri i r d) tes)
    else
        case (head str) of 'i' -> if isNothing i
                                    then poblarLaberinto (Lab (Tri i r d) tes) (tail str)
                                  else paredAbierta (izquierda (Lab (Tri i r d) tes)) (tail str)
                           'r' -> if isNothing r
                                    then poblarLaberinto (Lab (Tri i r d) tes) (tail str)
                                  else paredAbierta (recto (Lab (Tri i r d) tes)) (tail str)
                           'd' -> if isNothing d
                                    then poblarLaberinto (Lab (Tri i r d) tes) (tail str)
                                  else paredAbierta (derecha (Lab (Tri i r d) tes)) (tail str)

-- ** derrumbeLaberinto
-- | Se deshace del laberinto alcanzable en el destino de una ruta dada
derrumbeLaberinto :: Laberinto -> [Char] -> Char -> Laberinto
derrumbeLaberinto (Lab (Tri i r d) tes) str dir =
    if str == []
        then (Lab (Tri i r d) tes)
    else
        derrumbaPared(seguirRuta (Lab (Tri i r d) tes) str) dir

-- ** derrumbaPared
-- | Derrumba una pared de la trifurcación del laberinto actual
derrumbaPared :: Laberinto -> Char -> Laberinto
derrumbaPared (Lab (Tri i r d) tes) dir =
    case dir of 'i' -> (Lab (Tri Nothing r d) tes)
                'r' -> (Lab (Tri i Nothing d) tes)
                'd' -> (Lab (Tri i r Nothing) tes)


-- acumularRuta (Lab (Tri i r d) tes) str = 
--     if str == []
--       then (Lab (Tri i r d) tes)
--     else
--       case (head str) of 'i' -> acumularRuta' (izquierda (Lab (Tri i r d) tes)) (tail str) (Lab (Tri i r d) tes) 
--                          'r' -> acumularRuta' (recto (Lab (Tri i r d) tes)) (tail str) (Lab (Tri i r d) tes) 
--                          'd' -> acumularRuta' (derecha (Lab (Tri i r d) tes)) (tail str) (Lab (Tri i r d) tes) 

-- acumularRuta' (Lab (Tri i r d) tes) str (Lab (Tri i_acc r_acc d_acc) tes_acc) =
--     if str == []
--       then (Lab (Tri i r d) tes)
--     else
--       case (head str) of 'i' -> acumularRuta' $ (izquierda (Lab (Tri i r d) tes)) (tail str) (Lab (relacionaCamino (Tri i_acc r_acc d_acc) (Lab (Tri i r d) tes) 'i') tes_acc)

--                          'r' -> acumularRuta' $ (recto (Lab (Tri i r d) tes)) (tail str) (Lab (relacionaCamino (Tri i_acc r_acc d_acc) (Lab (Tri i r d) tes) 'r') tes_acc)
--                          'd' -> acumularRuta' $ (derecha (Lab (Tri i r d) tes)) (tail str) (Lab (relacionaCamino (Tri i_acc r_acc d_acc) (Lab (Tri i r d) tes) 'd') tes_acc)

-- * Funciones de validación 

-- ** rutaValida
-- | Verifica que un string de ruta solo contenga 'i','r' ó 'd'
rutaValida :: String -> Bool
rutaValida str =
    if str == "" then False
    else and $ map (letraValida) str

-- ** letraValida
-- | Verifica que un caracter sea 'i','r' ó 'd'
letraValida :: Char -> Bool
letraValida x 
    | or $ map (x ==) "rid" = True
    | otherwise = False

-- ** tesoroLocal
-- | Retorna el tesoro del laberinto actual
tesoroLocal :: Laberinto -> Maybe Tesoro
tesoroLocal (Lab tri tes) = tes

-- ** trifurcacionLocal
-- | Retorna la trifurcación de laberinto actual
trifurcacionLocal :: Laberinto -> Trifurcacion
trifurcacionLocal (Lab tri tes) = tri


-- * Otras funciones

-- ** clear
-- | Limpia la pantalla
clear :: IO ()
clear = putStrLn "\ESC[2J"