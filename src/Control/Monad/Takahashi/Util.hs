module Control.Monad.Takahashi.Util where
import Control.Monad.State
import Data.List(isPrefixOf)

stateSandbox :: MonadState s m => m a -> m a
stateSandbox f = do
  tmp <- get 
  res <- f
  put tmp
  return res

sub :: Eq a => [a] -> [a] -> [a] -> [a]
sub _ _ [] = []
sub x y str@(s:ss)
  | isPrefixOf x str = y ++ drop (length x) str
  | otherwise = s:sub x y ss

