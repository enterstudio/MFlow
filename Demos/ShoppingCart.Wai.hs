{-# OPTIONS -XDeriveDataTypeable -XScopedTypeVariables #-}
module Test where

{-
A stateless flow example. Convert it into persistent by uncommenting {- step -} and see the differences.

after 10 seconds without user interaction, the process is killed (set by setTimeout)
:l demos\shoppingCart.Wai.hs
-}

import MFlow.Wai
import MFlow.Forms
import Text.XHtml
import MFlow.Forms.XHtml
import Control.Concurrent
import Network.Wai.Handler.Warp
import MFlow.Forms.Admin
import qualified Data.Vector as V



main= do
--   syncWrite SyncManual
   putStrLn $ options messageFlows
   forkIO $ run   80   $ waiMessageFlow messageFlows
   adminLoop


options msgs= "in the browser navigate to\n\n" ++
     concat [ "http://localhost/"++ i ++ "\n" | (i,_) <- msgs]

messageFlows=  [("noscript",   runFlow shopCart )
               ,("stateless", stateless st)]

st _ = return "hi"

--shopCart1 :: V.Vector Int -> FlowM (Workflow IO) b
shopCart  = do
   setTimeouts 10 0
   shopCart1 (V.fromList [0,0,0:: Int])
   where
   shopCart1 cart=  do
     i <- {-step . -} ask
           $ table ! [border 1,thestyle "width:20%;margin-left:auto;margin-right:auto"]
             <<< caption << "choose an item"
             ++> thead << tr << concatHtml[ th << bold << "item", th << bold << "times chosen"]
             ++> (tbody
                  <<< (tr <<< td <<< wlink  0 (bold <<"iphone") <++  td << ( bold << show ( cart V.! 0))
                  <|>  tr <<< td <<< wlink  1 (bold <<"ipad")   <++  td << ( bold << show ( cart V.! 1))
                  <|>  tr <<< td <<< wlink  2 (bold <<"ipod")   <++  td << ( bold << show ( cart V.! 2)))
                  )
     let newCart= cart V.// [(i, cart V.! i + 1 )]
     shopCart1 newCart
