Page 50155 "Results Status Labels"
{
    PageType = Document;
    SourceTable = "Results Status";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(StatusMsg1; Rec."Status Msg1")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Status Msg1 field.';
                }
                field(StatusMsg2; Rec."Status Msg2")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Status Msg2 field.';
                }
                field(StatusMsg3; Rec."Status Msg3")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Status Msg3 field.';
                }
                field(StatusMsg4; Rec."Status Msg4")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Status Msg4 field.';
                }
                field(StatusMsg5; Rec."Status Msg5")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Status Msg5 field.';
                }
                field(StatusMsg6; Rec."Status Msg6")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg6 field.';
                }
                field(StatusMsg7; Rec."Status Msg7")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg7 field.';
                }
                field(StatusMsg8; Rec."Status Msg8")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg8 field.';
                }
                field(OrderNo; Rec."Order No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Order No field.';
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prefix field.';
                }
                field(ManualStatusProcessing; Rec."Manual Status Processing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Manual Status Processing field.';
                }
                field(StudentsCount; Rec."Students Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Students Count field.';
                }
            }
        }
    }

    actions { }
}

