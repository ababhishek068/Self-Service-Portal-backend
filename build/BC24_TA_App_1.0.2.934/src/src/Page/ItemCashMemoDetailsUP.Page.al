page 50517 "ItemCash Memo Details UP"
{
    PageType = ListPart;
    SourceTable = "Imprest Memo Lines";
    SourceTableView = WHERE("Imprest Type" = FILTER(ItemCash));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control18)
            {
                ShowCaption = false;
                field("Imprest Type"; Rec."Imprest Type")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Imprest Type field.';
                }
                field(No; Rec.No)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Account No:"; Rec."Account No:")
                {
                    Caption = 'Item No.';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Item Name';
                    Editable = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Item Name field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Unit Cost (LCY) field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount field.';

                    trigger OnValidate()
                    begin
                        /*{Get the total amount paid}
                        Bal:=0;
                        
                        PayHeader.RESET;
                        PayHeader.SETRANGE(PayHeader."Line No.",No);
                        IF PayHeader.FINDFIRST THEN
                          BEGIN
                            PayLine.RESET;
                            PayLine.SETRANGE(PayLine.No,PayHeader."Line No.");
                            IF PayLine.FIND('-') THEN
                              BEGIN
                                REPEAT
                                  Bal:=Bal + PayLine."Pay Mode";
                                UNTIL PayLine.NEXT=0;
                              END;
                          END;
                        //Bal:=Bal + Amount;
                        
                        IF Bal > PayHeader.Amount THEN
                          BEGIN
                            ERROR('Please ensure that the amount inserted does not exceed the amount in the header');
                          END;
                          */

                    end;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Issued field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Budgetary Control A/C"; Rec."Budgetary Control A/C")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Budgetary Control A/C field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Check Line Budget")
            {
                Caption = 'Check Line Budget';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Check Line Budget action.';
            }
        }
    }
}

