import GHC
import GHC.Paths (libdir)
import DynFlags
 
main = 
    defaultErrorHandler defaultFatalMessager defaultFlushOut $
      runGhc (Just libdir) $ 
        do dflags <- getSessionDynFlags
           setSessionDynFlags dflags
           target <- guessTarget "./data/Main.hs" Nothing
           setTargets [target]
           load LoadAllTargets
           modSum <- getModSummary $ mkModuleName "Main"
           p <- parseModule modSum
           t <- typecheckModule p
           d <- desugarModule t
           l <- loadModule d
           n <- getNamesInScope
           c <- return $ coreModule d
           g <- getModuleGraph
           mapM showModule g     
           return ()
