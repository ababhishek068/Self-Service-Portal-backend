Table 50896 "Cash Office User Template"
{
    DataCaptionFields = UserID;
    LookupPageId = "Cash Office User Template UP";
    fields
    {
        field(1; UserID; Code[30])
        {
            Description = 'Stores the reference of the user in the database';
            NotBlank = true;

            TableRelation = "User Setup"."User ID";
        }
        field(2; "Receipt Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const("Cash Receipts"));
        }
        field(3; "Receipt Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Receipt Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(4; "Payment Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the payment journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
        }
        field(5; "Payment Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the payment journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SetRange(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(6; "Petty Cash Template"; Code[20])
        {
            Description = 'Stores the reference to the petty cash payment voucher in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
        }
        field(7; "Petty Cash Batch"; Code[20])
        {
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Petty Cash Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Petty Cash Template", "Petty Cash Template");
                UserTemp.SetRange(UserTemp."Petty Cash Batch", "Petty Cash Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(8; "Inter Bank Template Name"; Code[20])
        {
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
        }
        field(9; "Inter Bank Batch Name"; Code[20])
        {
            Description = 'Stores the reference to the inter bank transfer batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Inter Bank Template Name"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Inter Bank Template Name", "Inter Bank Template Name");
                UserTemp.SetRange(UserTemp."Inter Bank Batch Name", "Inter Bank Batch Name");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(10; "Default Receipts Bank"; Code[20])
        {
            Description = 'Stores the reference to the default receipts bank deposit account';
            TableRelation = "Bank Account"."No." where("Bank Type" = filter(Cash | "Chq Collection"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default Receipts Bank", "Default Receipts Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            //  ERROR('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(11; "Default Payment Bank"; Code[20])
        {
            Description = 'Stores the reference to the default payments bank deposit account';
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default Payment Bank", "Default Payment Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(12; "Default Petty Cash Bank"; Code[20])
        {
            Description = 'Stores the reference to the default petty cash account in the database';
            TableRelation = "Bank Account"."No." where("Bank Type" = const(Cash));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default Petty Cash Bank", "Default Petty Cash Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(112; "Default MPESA Cash Bank"; Code[20])
        {
            Description = 'Stores the reference to the default Mpesa cash account in the database';
            TableRelation = "Bank Account"."No." where("Bank Type" = const(Cash));

            trigger OnValidate()
            begin
                /*
                 UserTemp.Reset;
                 UserTemp.SetRange(UserTemp."Default MPESA Cash Bank", "Default MPESA Cash Bank");
                 if UserTemp.FindFirst then begin
                     repeat
                         if UserTemp.UserID <> Rec.UserID then begin
                             Error('Please note that another user has been assigned the same bank.');
                         end;
                     until UserTemp.Next = 0;
                 end;
  */
            end;

        }
        field(13; "Max. Cash Collection"; Decimal) { }
        field(14; "Max. Cheque Collection"; Decimal) { }
        field(15; "Max. Deposit Slip Collection"; Decimal) { }
        field(16; "Supervisor ID"; Code[20])
        {
            Description = 'Stores the reference for the supervisor for the specific teller';

            trigger OnLookup()
            begin
                // LoginMgt.LookupUserID("Supervisor ID");
            end;

            trigger OnValidate()
            begin
                // LoginMgt.ValidateUserID("Supervisor ID");
            end;
        }
        field(17; "Bank Pay In Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(General));
        }
        field(18; "Bank Pay In Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Bank Pay In Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Bank Pay In Journal Template", "Bank Pay In Journal Template");
                UserTemp.SetRange(UserTemp."Bank Pay In Journal Batch", "Bank Pay In Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(19; "Imprest Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
        }
        field(20; "Imprest  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
        }
        field(50000; "Claim Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
        }
        field(50001; "Claim  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Claim Template"));
        }
        field(50002; "Advance Template"; Code[20])
        {
            Caption = 'Other Advance Template';
            TableRelation = "Gen. Journal Template".Name where(Type=const(Payments));
        }
        field(50003; "Advance  Batch"; Code[20])
        {
            Caption = 'Other Advance  Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
        }
        field(50004; "Advance Surr Template"; Code[20])
        {
            Caption = 'Other Advance Surr Template';
            TableRelation = "Gen. Journal Template".Name where(Type=const(Payments));
        }
        field(50005; "Advance Surr Batch"; Code[20])
        {
            Caption = 'Other Advance Surr Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
        }
        field(50006; "Default Location"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(50014; "Item Template"; Code[20])
        {
            Caption = 'Item Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50015; "Item Batch"; Code[20])
        {
            Caption = 'Item Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Item Template"));
        }
        field(50016; "Source of Funds"; Code[20])
        {
            Caption = 'Default Source of Funds';
            TableRelation = "Dimension Value".code where("Global Dimension No." = filter(3));
        }
    }

    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        UserTemp: Record "Cash Office User Template";
}

