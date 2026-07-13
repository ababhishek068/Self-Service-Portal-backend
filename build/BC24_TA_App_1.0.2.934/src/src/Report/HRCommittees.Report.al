report 50099 "HR Committees"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("HR Committees"; "HR Committees")
        {
            RequestFilterFields = Code;
            column(Code; Code) { }
            column(Description; Description) { }
            column(Roles; Roles) { }

            column(Logo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            trigger OnPreDataItem()
            begin
                CompInf.get;
                CompInf.CalcFields(Picture);
            end;
        }
    }





    var
        CompInf: Record "Company Information";
}