module Main
       where

import qualified Data.ByteString.Lazy.Char8 as L

import           Control.Monad
import           Data.Functor
import           Data.Maybe
import           Network.Browser
import           Network.HTTP
import           Network.HTTP.Proxy
import           Network.URI
import           System.Directory
import           System.IO
import           System.FilePath

file :: String
file = "00-index.tar.gz"

addr :: String
addr = "http://hackage.haskell.org/packages/archive/" ++ file

main :: IO ()
main = do
  putStrLn $ "Trying to download " ++ addr
  let uri = fromJust . parseURI $ addr
  path <- (</> file) <$> getCurrentDirectory
  r <- liftM (\(_, resp) -> Right resp) . browse $ do
    setErrHandler (hPutStrLn stderr . ("http error: " ++))
    setOutHandler putStrLn
    setAuthorityGen (\_ _ -> return Nothing)
    request $ Request { rqURI     = uri
                      , rqMethod  = GET
                      , rqHeaders = [Header HdrUserAgent "cabal-install/1.18.0.5"]
                      , rqBody    = L.empty }
  case r of
    Left err  -> error err
    Right rsp -> case rspCode rsp of
          (2,0,0) -> do
            putStrLn ("Downloaded to " ++ path)
            L.writeFile path $ rspBody rsp

          (a,b,c) -> error $ "Error HTTP code: " ++ concatMap show [a,b,c]
