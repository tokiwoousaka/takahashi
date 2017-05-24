{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE GADTs #-}
module Main where
import Lib
import Control.Concurrent.MVar
import Control.Object
import Control.Monad.State
import Pipes
import Data.Maybe
import qualified Pipes.Prelude as P

main :: IO ()
main = do
  --day20150213takahashi
  --day20150530LensPrism
  --day20150704tadashisa
  --day20150913objective
  --day20150913objectiveSample 
  --day20151107pipes
  --day20151107pipesSample
  --day20160416NLNagoya
  --day20160416NLNagoyaSample
  --day20160627Sunotora
  --day20170206otr
  day20170521Church
  return ()

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

-----------------------------------------------
-- for day20151107pipes

--                          Proxy a' a  b' b m r
-- type Effect        m r = Proxy X  () () X m r
-- type Producer   b  m r = Proxy X  () () b m r
-- type Consumer a    m r = Proxy () a  () X m r
-- type Pipe     a b  m r = Proxy () a  () b m r

-- type Server   b' b m r = Proxy X  () b' b m r
-- type Client   a' a m r = Proxy a' a  () X m r

-- (>->) :: Monad m => Producer b m r -> Consumer b   m r -> Effect       m r
-- (>->) :: Monad m => Producer b m r -> Pipe     b c m r -> Producer   c m r
-- (>->) :: Monad m => Pipe   a b m r -> Consumer b   m r -> Consumer a   m r
-- (>->) :: Monad m => Pipe   a b m r -> Pipe     b c m r -> Pipe     a c m r

-- (>~) :: Monad m => Effect       m b -> Consumer b   m c -> Effect       m c
-- (>~) :: Monad m => Consumer a   m b -> Consumer b   m c -> Consumer a   m c
-- (>~) :: Monad m => Producer   y m b -> Pipe     b y m c -> Producer   y m c
-- (>~) :: Monad m => Pipe     a y m b -> Pipe     b y m c -> Pipe     a y m c

-- for :: Monad m => Producer b m r -> (b -> Effect       m ()) -> Effect       m r
-- for :: Monad m => Producer b m r -> (b -> Producer   c m ()) -> Producer   c m r
-- for :: Monad m => Pipe   x b m r -> (b -> Consumer x   m ()) -> Consumer x   m r
-- for :: Monad m => Pipe   x b m r -> (b -> Pipe     x c m ()) -> Pipe     x c m r

-- await :: Monad m => Consumer' a m aSource
-- await :: Monad m => Pipe a y m a

-- runEffect :: Monad m => Effect m r -> m r

-- P.stdinLn  :: MonadIO m           => Producer' String m ()
-- P.stdoutLn :: MonadIO m           => Consumer' String m ()
-- P.print    :: (MonadIO m, Show a) => Consumer' a      m r
-- P.map      :: Monad m             => (a -> b) -> Pipe a b m r

day20151107pipesSample :: IO ()
day20151107pipesSample = do
  runEffect $ P.stdinLn >-> P.take 3 >-> P.stdoutLn
  --runEffect $ P.stdinLn >-> P.take 3 >-> toTuple >-> P.print

toTuple :: Monad m => Pipe [a] (Int, [a], Maybe a) m ()
toTuple = P.map $ \lst -> (length lst, lst, listToMaybe lst)

hoges :: Monad m => Producer String m ()
hoges = each ["Hoge", "Piyo", "Fuga", "Hogera"]

-----------------------------------------------
-- for day20160416NLNagoya

data Counter a where
  PrintCount :: Counter ()
  Increment :: Counter ()

counter :: Int -> Object Counter IO
counter s = s @~ \case
  PrintCount -> get >>= liftIO . print
  Increment -> modify (+1)

day20160416NLNagoyaSample :: IO ()
day20160416NLNagoyaSample = do
  putStrLn " ---- sample for counter ---- "
  cntr <- new $ counter 10
  cntr.-PrintCount -- 10
  cntr.-Increment
  cntr.-Increment
  cntr.-Increment
  cntr.-Increment
  cntr.-PrintCount -- 14
  return ()
