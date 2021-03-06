{-# LANGUAGE OverloadedStrings #-}

module Decl.ParserSpec where

import Control.Monad
import System.Directory
import Data.Monoid
import Test.QuickCheck
import Test.Hspec
import Text.Megaparsec hiding (fromFile)
import Data.Either
import Text.Megaparsec.Text

import Lambda.Untyped.Parser (Lambda(..), lambda)

import Decl.Parser

declaration' :: Parser (Decl Lambda)
declaration' = declaration lambda


spec :: Spec
spec = do
    describe "declaration" $ do
        let p = parse declaration' ""
        it "parses a declaration" $ do
            p "def foo = x;"
                `shouldBe`
                    Right (Def "foo" (Var "x"))
    describe "file examples" $ do
        let path = "test/Examples/parse/decl/decl-"
            path' i = path <> i <> ".lm"
        let p f = fromFile f lambda
        forM_ ["00", "01", "02"] $ \i -> do
            it "parses decl-00.lm" $ do
                p (path' i) >>= (`shouldSatisfy` isRight)
