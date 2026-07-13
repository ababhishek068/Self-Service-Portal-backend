

table 51008 "Inventory Spares Handover"
{
    DrillDownPageId="Inventory Tools and spares";
    
    fields
    {
    
        field(50000; EntryNo; Integer)
        {
            Caption = 'EntryNo';
            DataClassification = ToBeClassified;
            Editable=false;
            AutoIncrement=true;
        }
        field(50001; "Issue No"; Code[20])
        {
            Caption = 'Issue No';
            DataClassification = ToBeClassified;
            // TableRelation="HR-Employee"."No." where(sta)
        }
        field(50002; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = ToBeClassified;
        }
        field(50003; "Issued by"; Code[50])
        {
            Caption = 'Issued by';
            DataClassification = ToBeClassified;
        }
        field(50004; "Issued To"; Code[50])
        {
            Caption = 'Issued To';
            DataClassification = ToBeClassified;
            TableRelation="HR-Employee"."No." where(Status=filter(Active));
        }
        field(50005; "Vehicle No"; Code[50])
        {
            Caption = 'Vehicle No';
            DataClassification = ToBeClassified;
            TableRelation="FLT-Vehicle Header"."No.";
            trigger OnValidate()
            begin
                vheader.Reset();
                vheader.SetRange(vheader."No.",Rec."Vehicle No");
                if vheader.FindFirst() then begin
                    "Chassis No":=vheader."Chassis Serial No.";
                    "Engine No":=vheader."Engine Serial No.";
                    Model:=vheader.Model;
                    "Year of Manufacture":=vheader."Year Of Manufacture";
                    "Loading Capacity ":=vheader.Capacity;
                    "Type of fuel":=vheader."Fuel Type";
                    Colour:=vheader."Body Color";
                    "Numbers of Cylinders ":=vheader.Cylinders;
                    "Plate No":=vheader."Registration No.";
                    
                end;
            end;
        }
        field(50006; Model; Code[20])
        {
            Caption = 'Model';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50007; "Plate No"; Code[50])
        {
            Caption = 'Plate No';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50008; "Chassis No"; Code[50])
        {
            Caption = 'Chassis No';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50009; "Engine No"; Code[50])
        {
            Caption = 'Engine No';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50010; "Year of Manufacture"; Integer)
        {
            Caption = 'Year of Manufacture';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50011; Colour; Text[20])
        {
            Caption = 'Colour';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50012; "Type of fuel"; option)
        {
            Caption = 'Type of fuel';
            OptionMembers = " ",Petrol,Diesel;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50013; "Loading Capacity "; Decimal)
        {
            Caption = 'Loading Capacity ';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
        field(50014; "Numbers of Cylinders "; Integer)
        {
            Caption = 'Numbers of Cylinders ';
            DataClassification = ToBeClassified;
            Editable=false;
            trigger OnValidate()
            begin
                TestField("Vehicle No");
            end;
        }
    }
    trigger OnInsert()
    begin
        "Issue Date":=Today;
        "Issued by":=UserId;
    end;
    var
    vheader: Record "FLT-Vehicle Header";

}
