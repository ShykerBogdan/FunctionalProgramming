module Lib where 

data Phone = Phone { phoneNumber :: String } 
           | Phones { phoneNumbers :: [String] }    
            
instance Show Phone where
    show(Phone a) = "Phone: " ++ show a
    show(Phones a) = "Phones: " ++ show a

data Day = Day Int 
    deriving (Eq)
instance Show Day where 
    show (Day d) = show d

data Month = Month Int 
    deriving (Eq)
instance Show Month where 
    show (Month d) = show d

data Time = Time Int Int

instance Show Time where
    show(Time a b) = show a ++ ":" ++ show b

data Date = Date Day Month

instance Show Date where
    show(Date a b) = show a ++ "." ++ show b

data DateWithTime = DateWithTime Day Month Time

instance Show DateWithTime where
    show(DateWithTime a b c) = show a ++ "." ++ show b ++ " " ++ show c

data Meet = Meet { dateWithTime :: DateWithTime
                 , meetingPoint
                 , description :: String
                 , isHappened :: Bool
                 }

instance Show Meet where
    show(Meet a b c d) = "\n\t    Meet:" ++
                         "\n\t\tDate: " ++ show a ++
                         "\n\t\tMeeting point: " ++ show b ++
                         "\n\t\tDescription: " ++ show c ++
                         "\n\t\tDid the meeting take place? " ++ show d ++ "\n\t"

data People = People { name :: String
                     , phone :: Phone
                     , dateOfBirdth :: Date
                     , meets :: [Meet]
                     }

instance Show People where
    show(People a b c d) = "\n    People:" ++
                        "\n\tName: " ++ show a ++
                        "\n\t" ++ show b ++
                        "\n\tBirdthday: " ++ show c ++
                        "\n\tMeets: " ++ show d ++ "\n"

(+++) :: Phone -> String -> Phone
(+++) (Phone a) q = Phones [a,q] 
(+++) (Phones a) q = Phones (a ++ [q])


getMeet :: [People] -> String -> [Meet]
getMeet (x:xs) name_ = if (a == name_) then b else getMeet xs name_ 
    where People a _ _ b = x
    
getMeet [] _ = []        