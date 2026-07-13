Page 51167 "Compliance List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Grants Compliance";
    CardPageId = "Compliance Card";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GrantNo; Rec."Grant No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grant No field.';
                }
                field(ComplianceCode; Rec."Compliance Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Compliance Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        /*
            if UserMgt.GetPurchasesFilter1() <> '' then begin
              FilterGroup(2);
              SetFilter("Grant No",UserMgt.GetPurchasesFilter1());
              FilterGroup(0);
            end
            else
            SetFilter("Grant No",'%1',UserMgt.GetPurchasesFilter1());
            */
    end;
    //UserMgt: Codeunit UnknownCodeunit70134711;
}

