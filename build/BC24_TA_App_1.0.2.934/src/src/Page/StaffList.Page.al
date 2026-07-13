Page 50746 "Staff List"
{
    Editable = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Posting Group" = const('IMPREST'));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(TelexNo; Rec."Telex No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telex No. field.';
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Age field.';
                }
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(MaritalStatus; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field(BloodGroup; Rec."Blood Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Blood Group field.';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Weight field.';
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Height field.';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Religion field.';
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Citizenship field.';
                }
                field(PaymentsBy; Rec."Payments By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payments By field.';
                }
                field(IDNo; Rec."ID No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID No field.';
                }
                field(CustomerType; Rec."Customer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Type field.';
                }
                field(BirthCert; Rec."Birth Cert")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Birth Cert field.';
                }
                field(StaffNo; Rec."Staff No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }
            }
        }
    }

    actions { }
}

