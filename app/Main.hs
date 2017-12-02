{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Lib
import Database.HDBC
import Database.HDBC.ODBC
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy as BL
import Data.Csv
import qualified Data.Vector as V

main :: IO ()
main = do
    conn <- connectODBC "Provider=MSDASQL;Driver={MySQL ODBC 5.3 Unicode Driver};Server=localhost;Database=haskell;User=root;Password=root;Option=3;"
    z <- readFromDB conn
    print $ getMeet (setNotebook z) "Zhenia"
    disconnect conn

readFromCSV :: IO()
readFromCSV = do
    csvData <- BL.readFile "csv.csv"
    case decode NoHeader csvData of
        Left err -> putStrLn err
        Right v -> V.forM_ v $ \ (name :: String, phone_number :: String, bDay :: Int, bMonth :: Int, dayWT :: Int, monthWT :: Int, hourWT :: Int, minutesWT :: Int, description :: String, meetingPoint :: String, isHappened :: Int) ->
            print $ (name, phone_number, Date (Day (fromIntegral(bDay))) (Month (fromIntegral(bMonth))), DateWithTime (Day (fromIntegral(dayWT))) (Month (fromIntegral(monthWT))) (Time (fromIntegral(hourWT)) (fromIntegral(minutesWT))), description, meetingPoint, intToBool(isHappened))
            
readFromDB :: IConnection a => a -> IO [(String, String, Date, DateWithTime, String, String, Bool)]
readFromDB conn = do
  rslt <- quickQuery' conn query []
  return $ map unpack rslt
  where
    query =  "select people.name, phone_number, day(dateOfBirdth) as bDay, month(dateOfBirdth) as bMonth, day(dateWithTime) as dayWT, month(dateWithTime) as monthWT, hour(dateWithTime) as hourWT, minute(dateWithTime) as minutesWT, meets.description, meets.meetingPoint, meets.isHappened from people left join phones on people.name = phones.name left join meets on people.id = meets.id"
    unpack [SqlByteString name, SqlByteString phone_number, SqlInt64 bDay, SqlInt64 bMonth, SqlInt64 dayWT, SqlInt64 monthWT, SqlInt64 hourWT, SqlInt64 minutesWT, SqlByteString description, SqlByteString meetingPoint, SqlChar isHappened] =
         (BS.unpack name, BS.unpack phone_number, Date (Day (fromIntegral(bDay))) (Month (fromIntegral(bMonth))), DateWithTime (Day (fromIntegral(dayWT))) (Month (fromIntegral(monthWT))) (Time (fromIntegral(hourWT)) (fromIntegral(minutesWT))), BS.unpack description, BS.unpack meetingPoint, charToBool(isHappened))
    unpack x = error $ "Unexpected result: " ++ show x

charToBool :: Char -> Bool
charToBool ch 
    | ch == '\NUL' = False
    | otherwise = True

intToBool :: Int -> Bool
intToBool i 
    | i == 0 = False
    | otherwise = True

setNotebook :: [(String, String, Date, DateWithTime, String, String, Bool)] -> [People]
setNotebook (x:xs) = [] ++ [People { name = name_
                            , phone = Phone { phoneNumber = phone_ }
                            , dateOfBirdth = date_
                            , meets = [ Meet { dateWithTime = dateWithTime_
                                             , meetingPoint = meetingPoint_
                                             , description = description_
                                             , isHappened = isHappened_
                                             }
                                      ]
                            }] ++ setNotebook xs
        where (name_, phone_, date_, dateWithTime_, description_, meetingPoint_, isHappened_) = x

setNotebook [] = []

-- getNotebook :: [People]
-- getNotebook = [ People { name = "Zhenia"
--                        , phone = Phone { phoneNumber = "+380966319362" }
--                        , dateOfBirdth = Date (Day 30) September
--                        , meets = [ Meet { dateWithTime = DateWithTime (Day 1) September (Time 09 00)
--                                         , meetingPoint = "Meet 1"
--                                         , description = "None"
--                                         , isHappened = True 
--                                         } ,
--                                    Meet { dateWithTime = DateWithTime (Day 18) December (Time 19 00)
--                                         , meetingPoint = "Meet 2"
--                                         , description = "None"
--                                         , isHappened = True 
--                                         }
--                                 ]
--                         }
--               ]
