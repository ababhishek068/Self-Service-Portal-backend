Page 50145 "Int. Audit Auditee Resp. Card"
{
    PageType = Card;
    SourceTable = "Int. Audit Auditors";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Audit")
            {
                field("Workplan Name"; Rec."Workplan Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Workplan Name field.';
                }
                field("Audit Area Name"; Rec."Audit Area Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Audit Area Name field.';
                }
                field("Quarter Name"; Rec."Quarter Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quarter Name field.';
                }
                field(Objectives; Rec.Objectives)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Objectives field.';
                }
                field(Indicators; Rec.Indicators)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Indicators field.';
                }
                field(Findings; Rec.Findings)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Findings field.';
                }
                field(Risk; Rec.Risk)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Risk field.';
                }
                field(Remommendation; Rec.Remommendation)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Recommendation';
                    ToolTip = 'Specifies the value of the Recommendation field.';
                }
                field(AuditeeResponse; Rec."Auditee Response")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditee Response field.';
                }
                field("Auditee Department"; Rec."Auditee Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditee Department field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Notifications)
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Auditee Notifications";
                RunPageLink = Quarter = field("Quarter Code"),
                              Auditor = field("Auditor ID"),
                              Auditee = field(Auditee);
                ToolTip = 'Executes the Notifications action.';
            }
            action("Submit Response")
            {
                ApplicationArea = Basic;
                Image = Answers;
                Promoted = true;
                ToolTip = 'Executes the Submit Response action.';

                trigger OnAction()
                begin
                    if Rec."Quarter Code" = '' then Error('No record selected');
                    if Rec.Findings = '' then Error('You cannot respond before the auditor sunmits the findings');
                    Rec.Modify;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.setfilter(Auditee, Database.UserId);
    end;
}

