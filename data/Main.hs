import System.IO

foldHandle :: (x -> String -> IO x) -> IO x -> (x -> IO b) -> Handle -> IO b
foldHandle step begin done handle = begin >>= go
   where
   go current =
     do eof <- hIsEOF handle
        if eof 
        then done current
        else do line <- hGetLine handle
                next <- step current line 
                next `seq` go next

main :: IO ()
main = foldHandle (\() -> putStrLn . reverse) mempty mempty stdin 
