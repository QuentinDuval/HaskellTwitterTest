{-# LANGUAGE OverloadedStrings #-}
module OutputBuilder (
   buildHtml,
   buildHtmlFile
) where


import Control.Lens
import Data.ByteString.Lazy as B
import Text.Blaze.Html5 as H
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)

import TwitterInfo



newtype HtmlTweet = HtmlTweet { fromHtml :: TweetInfo }
instance ToMarkup HtmlTweet where
   toMarkup t = text (fromHtml t ^. content)


buildHtml :: [TweetInfo] -> Html
buildHtml tweets = H.docTypeHtml $ do
   H.head $
      H.title "Output:"
   H.body $ do
      let htweets = fmap HtmlTweet tweets
      H.ul $ mapM_ (H.li . H.toHtml) htweets


buildHtmlFile :: FilePath -> [TweetInfo] -> IO ()
buildHtmlFile filepath =
   B.writeFile filepath . renderHtml . buildHtml

