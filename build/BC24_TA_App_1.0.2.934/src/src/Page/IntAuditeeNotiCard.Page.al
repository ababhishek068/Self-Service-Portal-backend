Page 50148 "Int. Auditee Noti. Card"
{
    PageType = Card;
    SourceTable = "Int. Audit Notifications";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group("Notification")
            {
                field(Auditee; Rec.Auditee)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee field.';
                }
                field(AuditDate; Rec."Audit Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Audit Date field.';
                }
                field("Message"; Rec."Messages")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Messages field.';
                }
                field("Auditee Response"; Rec."Auditee Response")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditee Response field.';
                }

            }
        }
        area(factboxes)
        {


            systempart(Control1900383207; Links)
            {
                Caption = 'Attachments';
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

}

