query 50001 "Online Users"
{
    Caption = 'Online Users';
    QueryType = Normal;

    elements
    {
        dataitem(OnlineApplicationUsers; "Online Application Users")
        {
            column(CreatedDate; "Created Date") { }
            column(DateofBirth; "Date of Birth") { }
            column(Email; Email) { }
            column(Gender; Gender) { }
            column(IDNumber; "ID Number") { }
            column(LastloginDate; "Last login Date") { }
            column(OtherNames; "Other Names") { }
            column(Password; Password) { }
            column(SurName; SurName) { }

            column(SystemId; SystemId) { }

            column(UserId; UserId) { }
            column(PostalAddress; "Postal Address") { }
            column(Postalcode; "Postal code") { }
            column(City; City) { }
            column(Region; Region) { }
            column(HomePhoneNumber; "Home Phone Number") { }
            column(CellularPhoneNumber; "Cellular Phone Number") { }


        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
