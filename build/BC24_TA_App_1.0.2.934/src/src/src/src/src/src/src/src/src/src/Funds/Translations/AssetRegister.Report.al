report 50318 "Asset Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Source_of_Funds; "Source of Funds") { }
            column(Serial_No_; "Serial No.") { }
            column(Asset_Tag; "Asset Tag") { }
            column(Make_Model; "Make/Model") { }
            column(Installation_Date; "Installation Date") { }
            column(PV_Number; "PV Number") { }
            column(Original_Location; "Original Location") { }
            column(Location_Code; "Location Code") { }
            column(Replacement_Date; "Replacement Date") { }
            column(Purchase_Amount; "Purchase Amount") { }
            column(DepreciationRate; FADep."Depr. This Year % (Custom 1)") { }
            column(Depreciation; FADep.Depreciation) { }
            column(NetBook; Netbook) { }
            column(DisposalDate; FADep."Disposal Date") { }
            column(DisposalValue; FADep."Book Value on Disposal") { }
            column(Responsible_Employee; "Responsible Employee") { }
            column(Asset_Condition; "Asset Condition") { }
            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }

            trigger OnAfterGetRecord()
            begin
                Netbook := 0;
                FADep.reset;
                FADep.setrange("FA No.", "No.");
                if FADep.find('-') then begin
                    FADep.CalcFields(FADep."Book Value");
                    Netbook := FADep."Book Value";
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.get();
                CompInf.CalcFields(Picture);
            end;
        }

    }





    var
        FADep: Record "FA Depreciation Book";
        CompInf: Record "Company Information";
        Netbook: Decimal;
}