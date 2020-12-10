pageextension 50150 "ContactPageExt" extends "Contact Card"
{
    layout
    {
        addafter(General)
        {
            group(Security)
            {
                Visible = true;
                field(Password; 'Password')
                {
                    Caption = 'Password';
                    Visible = true;
                }
            }
        }
    }
}
