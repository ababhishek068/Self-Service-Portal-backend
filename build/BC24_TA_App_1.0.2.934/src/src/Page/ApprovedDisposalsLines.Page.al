Page 50457 "Approved Disposals Lines"
{
    PageType = ListPart;
    SourceTable = "Disposal Plan Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Disposal  No"; Rec."Disposal  No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Disposal  No field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field("Fixed Location"; Rec."Fixed Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fixed Location field.';
                }
                field("Item Life Span"; Rec."Item Life Span")
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Life Span';
                    ToolTip = 'Specifies the value of the Asset Life Span field.';
                }
                field("Tag No."; Rec."Tag No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tag No. field.';
                }
                field("Disposal Method"; Rec."Disposal Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Method field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disposal Amount';
                    ToolTip = 'Specifies the value of the Disposal Amount field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Type field.';
                }


                field("Justification For Disposal"; Rec."Justification For Disposal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Justification For Disposal field.';
                }




            }
        }
    }

    actions { }
}

