module Main where
import Lib
import Control.Concurrent.MVar

main :: IO ()
main = do
  --day20150213takahashi
  --day20150530LensPrism
  --day20150704tadashisa
  day20150913objective
  --day20150913objectiveSample 

-----------------------------------------------
-- for day20150913objective
-- ミーリマシン

newtype Mealy a b = Mealy
  { runMealy :: a -> (b, Mealy a b)
  }

strBuffer :: Mealy String (Int, String) 
strBuffer = f (0, "")
  where
    f :: (Int, String) -> Mealy String (Int, String)
    f (i, s) = Mealy $ \t -> let n = (i + 1, s ++ t) in (n, f n)

--modifyMVar :: MVar a -> (a -> IO (a, b)) -> IO b
(.!) :: MVar (Mealy a b) -> a -> IO b
m .! i = modifyMVar m $ \o -> do
   (res, next) <- return $ runMealy o i
   return (next, res)

day20150913objectiveSample :: IO ()
day20150913objectiveSample = do
  inst <- newMVar strBuffer
  res <- inst .! "Hoge"
  print res -- (1, "Hoge")
  res <- inst .! "Piyo"
  print res -- (2, "HogePiyo")
  res <- inst .! "Fuga"
  print res -- (3, "HogePiyoFuga")
  
