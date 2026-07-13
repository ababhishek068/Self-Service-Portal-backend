namespace Hijra.Hijra;

using Microsoft.Inventory.Location;

query 50102 "Responsibility Center"
{
    Caption = 'Responsibility Center';
    QueryType = Normal;
    
    elements
    {
        dataitem(ResponsibilityCenter; "Responsibility Center")
        {
            column("Code"; "Code")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(Address2; "Address 2")
            {
            }
            column(City; City)
            {
            }
            column(PostCode; "Post Code")
            {
            }
            column(CountryRegionCode; "Country/Region Code")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(FaxNo; "Fax No.")
            {
            }
            column(Name2; "Name 2")
            {
            }
            column(Contact; Contact)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(County; County)
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(HomePage; "Home Page")
            {
            }
            column(ContractGainLossAmount; "Contract Gain/Loss Amount")
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
