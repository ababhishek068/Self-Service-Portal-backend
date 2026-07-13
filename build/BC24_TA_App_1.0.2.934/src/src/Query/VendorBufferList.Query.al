Query 50042 "Vendor Buffer List"
{
    elements
    {
        dataitem(Vendor_User_Buffer; "Vendor User Buffer")
        {
            DataItemTableFilter = Status = filter(<> Cancelled);
            column(Company_Name; "Company Name") { }
            column(Company_Registration_No; "Company Registration No") { }
            column(UserID; UserID) { }
            column(Vendor_No; "Vendor No") { }
            column(Ownership; Ownership) { }
            column(Email; Email) { }
            column(Status; Status) { }
            column(Kra_Pin; "Kra Pin") { }
            column(Password; Password) { }
            column(Language; Language) { }
            column(Country; Country) { }
            column(Street_Address_Building_No; "Street Address/Building No") { }
            column(City; City) { }
            column(Postal_Code; "Postal Code") { }
            column(Mobile_Phone; "Mobile Phone") { }
            column(Rejection_Comments; "Rejection Comments") { }

            column(Telephone_No; "Telephone No") { }

            column(Vendor_Category; "Vendor Category") { }
            column(National_ID; "National ID") { }

        }
    }
}