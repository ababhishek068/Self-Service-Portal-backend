Page 50123 "Client List"
{
    //CardPageID = "Clients Card";
    PageType = List;
    SourceTable = Customer;
    ApplicationArea = All;
    //SourceTableView = where("Client Type"=const(Client));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                // field(Industry; Industry)
                // {
                //     ApplicationArea = Basic;
                // }
                // field(Version; Version)
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Client Type"; "Client Type")
                // {
                //     ApplicationArea = Basic;
                // }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s email address.';
                }
            }
        }
    }

    actions { }
}

