Page 50147 "Int. Auditee Notifications"
{
    PageType = List;
    SourceTable = "Int. Audit Notifications";
    CardPageId = "Int. Auditee Noti. Card";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
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
    }

}

