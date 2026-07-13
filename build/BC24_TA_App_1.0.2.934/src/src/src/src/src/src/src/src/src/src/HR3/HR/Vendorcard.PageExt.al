pageextension 50031 "Vendor card" extends "Vendor Card"
{
    layout
    {
        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify(GLN)
        {
            Visible = false;
        }
        // modify("VAT Registration No.")
        // {
        //     Caption = 'KRA PIN No.';
        // }
        addafter("Balance (LCY)")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Balance field.';
            }
        }
        addafter("VAT Registration No.")
        {
            field("TIN No"; "TIN No")
            {
                Caption = 'TIN No';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the TIN No';

            }
        }
        addafter(Name)
        {
            field("Vendor Category"; Rec."Vendor Category")
            {
                Caption = 'Supplier Category';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Supplier Category field.';
            }
            field("Vendor Type"; Rec."Vendor Type")
            {
                Caption = 'Supplier Type';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Supplier Type field.';
            }

            field(Trainer; Rec.Trainer)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Trainer field.';
            }
        }
        addafter("Privacy Blocked")
        {
            field("Blacklisted?";"Blacklisted?"){ Editable=false;}
            field("Blaclisting Start Date";"Blaclisting Start Date"){}
            field("Blacklisting Period";"Blacklisting Period"){}
            field("Blaclisting End Date";"Blaclisting End Date"){}
        }
        addafter("Vendor Posting Group")
        {
            field("Agpo Category"; Rec."Agpo Category")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Agpo Category field.';
            }
            // field("AGPO No"; Rec."AGPO No")
            // {
            //     Caption = 'AGPO Certificate No.';
            //     ApplicationArea = basic;
            //     ToolTip = 'Specifies the value of the AGPO Certificate No. field.';
            // }
            // field("Agpo Cert. Date"; Rec."Agpo Cert. Date")
            // {
            //     ApplicationArea = basic;
            //     ToolTip = 'Specifies the value of the Agpo Cert. Date field.';
            // }
            // field(Gender; Rec.Gender)
            // {
            //     ApplicationArea = basic;
            //     ToolTip = 'Specifies the value of the Gender field.';
            // }
            field("Vendor Eligibilty"; Rec."Vendor Eligibilty")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Vendor Eligibilty field.';
            }
        }
    }

    actions
    {
        addafter("Bank Accounts")
        {
            action(VendorRating)
            {
                Caption = 'Vendor Ratings';
                ApplicationArea = basic;
                Image = Ranges;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Vendor Ratings";
                RunPageLink = "Vendor No." = field("No.");
                ToolTip = 'Executes the Vendor Ratings action.';
            }
            action(VendorCategory)
            {
                Caption = 'Vendor Categories';
                ApplicationArea = basic;
                Image = Category;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Vendor Product Categories List";
                RunPageLink = "Vendor No" = field("No.");
                ToolTip = 'Executes the Vendor Categories action.';
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create Vendor");

    end;
    trigger OnAfterGetRecord()
    begin
        if (rec."Blaclisting End Date"=0D) or (rec."Blaclisting End Date"<Today) then begin
            //"Blacklisted?":=false;
            //rec.Modify();

        end;
    end;
}