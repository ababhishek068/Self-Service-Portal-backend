namespace PTL.HRMIS;
using PTL.HRMIS;

page 51523 "Performance Periods Setup"
{
    ApplicationArea = All;
    Caption = 'Performance Periods Setup';
    PageType = List;
    SourceTable = "Performance Review Periods";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date field.', Comment = '%';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date field.', Comment = '%';
                }
                field(Current; Rec.Current)
                {
                    ToolTip = 'Specifies the value of the Current field.', Comment = '%';
                }
                field("Closed By"; Rec."Closed By")
                {
                    ToolTip = 'Specifies the value of the Closed By field.', Comment = '%';
                    Editable = false;
                }
                field("Opened By"; Rec."Opened By")
                {
                    ToolTip = 'Specifies the value of the Opened By field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GeneratePerformanceHeaders)
            {
                ApplicationArea = All;
                Caption = 'Generate Staff KPIs';
                Promoted = true;
                PromotedCategory = Process;
                Image = AddContacts;
                ToolTip = 'Executes the Generate Performance Headers action.';

                trigger OnAction()
                var
                    //PTLFactory: Codeunit "PTL Factory";
                begin
                    Rec.TestField(Current);
                    //PTLFactory.GeneratePerformanceReviewKPIsByProject(Rec);
                end;
            }
            action(KPIS)
            {
                ApplicationArea = All;
                Caption = 'Period KPIs';
                Promoted = true;
                PromotedCategory = Process;
                Image = AddContacts;
                ToolTip = 'Executes the KPIS action.';
                RunObject = page "Performance KPI Setup";
                RunPageLink = "Period Code" = field("Period Code"), "Global Dimendion 1 Code" = field("Global Dimension 1 Code");
            }
        }
    }
}
