{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

-- Module      : Rifactor.Types
-- Copyright   : (c) 2015 Knewton, Inc <se@knewton.com>
--               (c) 2015 Tim Dysinger <tim@dysinger.net> (contributor)
-- License     : Apache 2.0 http://opensource.org/licenses/Apache-2.0
-- Maintainer  : Tim Dysinger <tim@dysinger.net>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Rifactor.Types where

import Control.Lens
import Data.Aeson.TH (deriveJSON)
import Network.AWS
import Network.AWS.Data
import Network.AWS.EC2.Types hiding (Region)
import Rifactor.Types.Internal (deriveOptions)

data Options =
  Options {_file :: FilePath
          ,_dry :: Bool
          ,_verbose :: Bool }

data Account =
  Account {_name :: String
          ,_accessKey :: String
          ,_secretKey :: String}

data Config =
  Config {_accounts :: [Account]
         ,_regions :: [Region]}

data OnDemand =
  OnDemand {_odInstance :: Instance}
  deriving (Show, Eq)

data Reserved
  = Reserved {_reEnv :: Env
             ,_reReservedInstances :: ReservedInstances}
  | UsedReserved {_reEnv :: Env
                 ,_reReservedInstances :: ReservedInstances
                 ,_reInstances :: [Instance]}
  | MoveReserved {_reEnv :: Env
                 ,_reReservedInstances :: ReservedInstances
                 ,_reInstances :: [Instance]}
  | SplitReserved {_reEnv :: Env
                  ,_reReservedInstances :: ReservedInstances
                  ,_reInstances :: [Instance]
                  ,_reNewInstances :: [Instance]}
  | CombineReserved {_reEnv :: Env
                    ,_reReservedInstances' :: [ReservedInstances]}
  | ResizeReserved {_reEnv :: Env
                   ,_reReservedInstances :: ReservedInstances
                   ,_reInstances :: [Instance]}
  deriving (Show,Eq)

instance Show Env
instance Eq Env

{- Lenses -}

$(makeLenses ''Account)
$(makeLenses ''Config)
$(makeLenses ''OnDemand)
$(makeLenses ''Options)
$(makeLenses ''Reserved)

{- JSON -}

$(deriveJSON deriveOptions ''Account)
$(deriveJSON deriveOptions ''Config)
$(deriveJSON deriveOptions ''Options)
$(deriveJSON deriveOptions ''Region)
