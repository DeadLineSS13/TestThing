#define FOV_PHASE_IN_TIME 5 //����� �� ������������
#define FOV_HIDE_ALPHA    0 //����� ������������ �������

/atom/var/fovCanBeHide = FALSE
/mob/fovCanBeHide      = TRUE
/obj/item/fovCanBeHide = TRUE



//���������� �� � ���������, �� �����. � ��� ���� ���������

/obj/screen/fullscreen/fov
	icon = 'icons/mob/hide.dmi'
	icon_state = "combat"
	name = "fov"
	blend_mode = BLEND_MULTIPLY
	screen_loc = "1,1"
	layer = 19
	fovCanBeHide = FALSE

/client/var/useFov = TRUE