{-# LANGUAGE OverloadedStrings #-}
module OutputBuilder (
   buildHtml,
   buildHtmlFile
) where


import Control.Lens
import qualified Data.ByteString.Lazy as B
import Data.List(intersperse)
import Data.Monoid
import Data.Text (Text)
import qualified Data.Text as T
import Text.Blaze.Html5 as H
import Text.Blaze.XHtml5.Attributes(href)
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)

import TwitterInfo



newtype HtmlTweet = HtmlTweet { fromHtml :: TweetInfo }
instance ToMarkup HtmlTweet where
   toMarkup t =
      let ws = T.words (fromHtml t ^. content)
          ms = fmap wordToMarkup ws
      in mconcat (intersperse (text " ") ms)


wordToMarkup :: Text -> Markup
wordToMarkup t
   | "http://" `T.isInfixOf` t = a ! href (textValue t) $ text t
   | otherwise = text t


buildHtml :: [TweetInfo] -> Html
buildHtml tweets = H.docTypeHtml $ do
   H.head $
      H.title "Twitter output"
   H.body $ do
      H.p (text "Output:")
      let htweets = fmap HtmlTweet tweets
      H.ul $ mapM_ (H.li . H.toHtml) htweets


buildHtmlFile :: FilePath -> [TweetInfo] -> IO ()
buildHtmlFile filepath =
   B.writeFile filepath . renderHtml . buildHtml

