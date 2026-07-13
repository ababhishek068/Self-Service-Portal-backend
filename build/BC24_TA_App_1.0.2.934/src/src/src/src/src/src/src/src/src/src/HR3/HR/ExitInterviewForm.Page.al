page 51472 "Exit Interview Form"
{
    ApplicationArea = All;
    Caption = 'Exit Interview Form';
    PageType = Card;
    SourceTable = "Exit Interview Questionare";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
                field("Exit Interview Date"; Rec."Exit Interview Date")
                {
                    ToolTip = 'Specifies the value of the Exit Interview Date field.', Comment = '%';
                }
            }
            group("Reason for Leaving")
            {
                Caption = 'Reason for Leaving';
                
                field("Dissatisfaction with salary"; Rec."Dissatisfaction with salary")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with salary field.', Comment = '%';
                }
                field("Dissatis with the type of work"; Rec."Dissatis with the type of work")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with the type of work field.', Comment = '%';
                }
                field("Dissatis with supervisor"; Rec."Dissatis with supervisor")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with supervisor field.', Comment = '%';
                }
                field("Dissatis with co-workers"; Rec."Dissatis with co-workers")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with co-workers field.', Comment = '%';
                }
                field("Dissati with working condition"; Rec."Dissati with working condition")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with working condition field.', Comment = '%';
                }
                field("Dissatisfaction with benefits"; Rec."Dissatisfaction with benefits")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with benefits field.', Comment = '%';
                }
                field("Dissatis with assignment "; Rec."Dissatis with assignment ")
                {
                    ToolTip = 'Specifies the value of the Dissatisfaction with assignment field.', Comment = '%';
                }
                field("Unable to be promoted"; Rec."Unable to be promoted")
                {
                    ToolTip = 'Specifies the value of the Unable to be promoted field.', Comment = '%';
                }
                field("Family Problem"; Rec."Family Problem")
                {
                    ToolTip = 'Specifies the value of the Family Problem field.', Comment = '%';
                }
                field("Health problem"; Rec."Health problem")
                {
                    ToolTip = 'Specifies the value of the Health problem field.', Comment = '%';
                }
                field("To further education"; Rec."To further education")
                {
                    ToolTip = 'Specifies the value of the To further education field.', Comment = '%';
                }
                field("To go abroad"; Rec."To go abroad")
                {
                    ToolTip = 'Specifies the value of the To go abroad field.', Comment = '%';
                }
                field(Retirement; Rec.Retirement)
                {
                    ToolTip = 'Specifies the value of the Retirement field.', Comment = '%';
                }
                field("Disciplinary Measure"; Rec."Disciplinary Measure")
                {
                    ToolTip = 'Specifies the value of the Disciplinary Measure field.', Comment = '%';
                }
                field(Death; Rec.Death)
                {
                    ToolTip = 'Specifies the value of the Death field.', Comment = '%';
                }
                field(Other; Rec.Other)
                {
                    ToolTip = 'Specifies the value of the Other field.', Comment = '%';
                }
                field("Reason for Other"; Rec."Reason for Other")
                {
                    ToolTip = 'Specifies the value of the Reason for Other field.', Comment = '%';
                }
                field("what is the main reason?"; Rec."what is the main reason?")
                {
                    ToolTip = 'Specifies the value of the If several, what is the main reason? field.', Comment = '%';
                }
                field("Answer number"; Rec."Answer number")
                {
                    ToolTip = 'Specifies the value of the Answer number field.', Comment = '%';
                }
            }
            group("Plan After Leaving")
            {
                Caption = 'Plan After Leaving';
                
                field("To join another company?"; Rec."To join another company?")
                {
                    ToolTip = 'Specifies the value of the To join another company? field.', Comment = '%';
                }
                field("Which sector?"; Rec."Which sector?")
                {
                    ToolTip = 'Specifies the value of the Which sector? field.', Comment = '%';
                }
                field("If other, specify secor"; Rec."If other, specify secor")
                {
                    ToolTip = 'Specifies the value of the If other, specify secor field.', Comment = '%';
                }
                field(Attraction; Rec.Attraction)
                {
                    ToolTip = 'Specifies the value of the Please indicate the major decision element or offer that attracted to join the new company/organization field.', Comment = '%';
                }
                field("To start own business"; Rec."To start own business")
                {
                    ToolTip = 'Specifies the value of the To start own business field.', Comment = '%';
                }
                field("If other, Please indicated"; Rec."If other, Please indicated")
                {
                    ToolTip = 'Specifies the value of the If other, Please indicated field.', Comment = '%';
                }
            }
        }
    }
}
