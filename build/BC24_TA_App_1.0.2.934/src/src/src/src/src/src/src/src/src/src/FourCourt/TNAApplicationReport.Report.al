report 50336 "TNA Application Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("TNA Application List"; "TNA Application List")
        {
            RequestFilterFields = Code;
            column("Code"; Code) { }

            dataitem(TNA_Application_Lines; "TNA Application List")
            {
                column(Proposed_Intervention; "Proposed Intervention") { }
                column(justification_Skill_Gap_; "justification(Skill Gap)") { }
                column(Proposed_Start_Date; "Proposed Start Date") { }
                column(Duration_Units; "Duration Units") { }
                column(Proposed_End_Date; "Proposed End Date") { }
                column(Source_of_Funds; "Source of Funds") { }

                column(Location; Location) { }

                column(Need_Source; "Need Source") { }
                column(Quarter_Offered; "Quarter Offered") { }
                column(Trainer; Trainer) { }
                column(Trainer_Name; "Trainer Name") { }
                column(Cost_Of_Training; "Cost Of Training") { }
                column(Daily_Subsistence; "Daily Subsistence") { }
                column(Transport_Transfers; "Transport Transfers") { }
                column(Total_Cost; "Total Cost") { }
            }
            trigger OnAfterGetRecord()
            begin

            end;
        }

    }

    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;

    var
        CompInf: Record "Company Information";
}