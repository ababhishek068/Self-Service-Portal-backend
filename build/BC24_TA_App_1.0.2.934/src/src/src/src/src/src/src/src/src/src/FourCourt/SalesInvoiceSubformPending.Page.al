page 50997 "Sales Invoice Subform Pending"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";

    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
                    Editable = false;

                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = Rec.Type <> Rec.Type::" ";
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                    Editable = false;

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;

                    ToolTip = 'Specifies a description of the entry, which is based on the contents of the Type and No. fields.';
                    Editable = false;

                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Editable = false;

                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';



                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;

                    ToolTip = 'Specifies how many units are being sold.';


                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';


                }


                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;


                    ToolTip = 'Specifies the price for one unit on the sales line.';


                }
                field("Actual Shipped Qty"; Rec."Actual Shipped Qty")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Actual Shipped Qty field.';
                }
                field("Shipped Qty Variance"; Rec."Shipped Qty Variance")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shipped Qty Variance field.';
                }





            }

        }
    }

}

