report 50353 "TNA Form Report"
{
    ApplicationArea = All;
    Caption = 'TNA Form Report';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(TNAApplicationList; "TNA Application List")
        {
            column(cdCode; "Code") { }

            column(Proposed_End_Date; "Proposed End Date") { }

            column(CostOfTraining; "Cost Of Training") { }
            column(DailySubsistence; "Daily Subsistence") { }
            column(DurationUnits; "Duration Units") { }
            column(EntryNo; "Entry No") { }
            column(Location; Location) { }
            column(NeedSource; "Need Source") { }
            column(ProposedIntervention; "Proposed Intervention") { }
            column(ProposedStartDate; "Proposed Start Date") { }
            column(QuarterOffered; "Quarter Offered") { }
            column(SourceofFunds; "Source of Funds") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TotalCost; "Total Cost") { }
            column(Trainer; Trainer) { }
            column(TrainerName; "Trainer Name") { }
            column(TransportTransfers; "Transport Transfers") { }
            column(justificationSkillGap; "justification(Skill Gap)") { }

            column(strEmpNo; strEmpNo) { }
            column(strEmpName; strEmpName) { }
            trigger OnAfterGetRecord();
            var
                HD: Record "HR Training Needs Analysis";
            begin
                HD.Reset();
                HD.SetRange(HD.Code, TNAApplicationList.Code);
                if HD.find('-') then begin
                    strEmpName := hd."Employee Name";

                end;
            end;


            trigger OnPreDataItem();
            begin

            end;

        }

    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
    trigger OnPreReport()
    begin

        if CompanyInfo.Get() then begin
            CompanyInfo.CalcFields(CompanyInfo.Picture);
            CompanyInfo.CalcFields(CompanyInfo."Company Watermark");
        end;

    end;

    var
        CompanyInfo: Record "Company Information";
        strEmpName: Text[20];
        strEmpNo: Code[20];




}
