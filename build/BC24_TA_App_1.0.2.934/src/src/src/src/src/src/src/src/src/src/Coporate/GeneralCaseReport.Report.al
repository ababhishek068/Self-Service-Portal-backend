report 50060 "General Case Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Cases; Cases)
        {
            RequestFilterFields = "Case No";
            column(Case_Description; "Case Description") { }
            column(Case_Date; "Case Date") { }
            column(Source_of_Complaint; "Source of Complaint") { }
            column(Amount_Involved; "Amount Involved") { }
            column(Amount_Recovered; "Amount Recovered") { }

            dataitem("Case Complainant"; "Case Complainant")
            {
                DataItemLink = "Case No" = field("Case No");
                column(Case_No; "Case No") { }
                column(Name; Name) { }
                column(ID_Number; "ID Number") { }

                column(Sacco_Name; "Sacco Name") { }
                column(Care_Of; "Care Of") { }
                column(Region; Region) { }
                column(Tribe; Tribe) { }
                trigger OnAfterGetRecord()
                begin
                    if cas.get("Case No") then;
                end;
            }
            dataitem("Case Suspect"; "Case Suspect")
            {
                DataItemLink = "Case No" = field("Case No");
                column(SuspectName; Name) { }
                column(suspectPhone_No; "Phone No") { }
                column(SuspectRegion; Region) { }
            }
            dataitem("Case Withness"; "Case Withness")
            {
                DataItemLink = "Case No" = field("Case No");
                column(WithnessName; Name) { }
                column(WithnessPhone_No; "Phone No") { }

            }
        }
    }
    requestpage
    {


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }
    var
        Cas: record cases;
}