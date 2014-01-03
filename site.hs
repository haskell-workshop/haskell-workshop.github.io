--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["colophon.md", "contact.md", "events.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= permalinkedUrl

    match "posts/*" $ do
        route $ permalinkedRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= permalinkedUrl

    match "pages/*" $ do
        route $ permalinkedRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= permalinkedUrl

    match "tutorials/*" $ do
        route $ permalinkedRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= permalinkedUrl

    match "events/*" $ do
        route $ permalinkedRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= permalinkedUrl

    create ["archive/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= permalinkedUrl

    create ["events/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "_events/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Events"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= permalinkedUrl

    create ["tutorials/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "_tutorials/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Tutorials"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= permalinkedUrl

    --Indexpage has its own template for now, hardcoded
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= permalinkedUrl

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

-- | Compiler form of 'permalinkedUrlWith' which automatically turns index.html
-- links into just the directory name
permalinkedUrl :: Item String -> Compiler (Item String)
permalinkedUrl item = do
    route <- getRoute $ itemIdentifier item
    return $ case route of
        Nothing -> item
        Just r  -> fmap permalinkedUrlWith item


--------------------------------------------------------------------------------
-- | permalinked URLs in HTML
permalinkedUrlWith :: String  -- ^ HTML to wordpressify
                     -> String  -- ^ Resulting HTML
permalinkedUrlWith = withUrls convert
  where
    convert x = replaceAll "/index.html" (const "/") x

--------------------------------------------------------------------------------
permalinkedRoute :: Routes
permalinkedRoute =
    gsubRoute "posts/" (const "") `composeRoutes`
        gsubRoute "pages/" (const "") `composeRoutes`
            gsubRoute "_events/" (const "/events/") `composeRoutes`
                gsubRoute "_tutorials/" (const "/tutorials/") `composeRoutes`
                    gsubRoute "^[0-9]{4}-[0-9]{2}-[0-9]{2}-" (map replaceWithSlash)`composeRoutes`
                        gsubRoute ".md" (const "/index.html")
    where replaceWithSlash c = if c == '-' || c == '_'
                                   then '/'
                                   else c

