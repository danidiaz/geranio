import GHC
import GHC.Paths (libdir)
import DynFlags
import Control.Monad
import Control.Monad.IO.Class
 
main = 
    defaultErrorHandler defaultFatalMessager defaultFlushOut $
      runGhc (Just libdir) $ 
        do dflags <- getSessionDynFlags
           let dflags' = dflags { hscTarget = HscNothing
                                , ghcLink =  NoLink 
                                }
           setSessionDynFlags dflags'
           target <- guessTarget "./data/Main.hs" Nothing
           setTargets [target]
           _ <- depanal [] False
--           load LoadAllTargets
           modSum <- getModSummary $ mkModuleName "Main"
           p <- parseModule modSum
           t <- typecheckModule p
           d <- desugarModule t
           l <- loadModule d
           n <- getNamesInScope
           c <- return $ coreModule d
           g <- getModuleGraph
           gr <- mapM showModule g     
           liftIO $ traverse print gr
           return ()
