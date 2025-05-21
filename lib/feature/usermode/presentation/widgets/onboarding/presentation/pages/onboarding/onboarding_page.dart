// presentation/pages/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:m9/core/config/assets/app_images.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/core/routes/app_routes.dart';
import '../../../domain/entities/onboarding_model.dart';
import '../../../domain/repositories/permission_repository.dart';
import '../../widgets/dot_indicator.dart';
import '../../widgets/primary_button.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<Onboarding> {
  // ຄອບຄຸມການເລື່ອນໜ້າ
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ຂໍ້ມູນສຳລັບໜ້າ onboarding
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: AppImages.splash1,
      title: AppConstants.title1,
      description: AppConstants.deliveryOptimization,
    ),
    OnboardingPage(
      image: AppImages.splash2,
      title: AppConstants.title2,
      description: AppConstants.packageTracking,
    ),
    OnboardingPage(
      image: AppImages.splash3,
      title: AppConstants.title3,
      description: AppConstants.deliveryOptimization,
    ),
    OnboardingPage(
      image: AppImages.splash4,
      title: AppConstants.title4,
      description: AppConstants.deliveryOptimization,
    ),
  ];

  // ພາບອ້າງອີງຈາກ repository
  late final PermissionRepository _permissionRepository;

  @override
  void initState() {
    super.initState();
    _permissionRepository = GetIt.instance<PermissionRepository>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ການຈັດການການກົດປຸ່ມ ຕໍ່ໄປ
  void _handleNextButton() async {
    if (_currentPage == _pages.length - 1) {
      // ຖ້າເປັນໜ້າສຸດທ້າຍ, ຂໍການອະນຸຍາດແລະໄປໜ້າ login
      setState(() {
        Navigator.pushNamed(context, AppRoutes.login);
      });
    } else {
      // ເລື່ອນໄປໜ້າຕໍ່ໄປ
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ການຈັດການການກົດປຸ່ມ Skip
  void _handleSkip() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ສ່ວນເທິງສຸດພ້ອມປຸ່ມ Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _handleSkip,
                    child: const Text(
                      AppConstants.skipText,
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ສ່ວນເນື້ອຫາຫຼັກ
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index]);
                },
              ),
            ),

            // ສ່ວນຕົວຊີ້ບອກຈຸດ
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => DotIndicator(isActive: index == _currentPage),
              ),
            ),

            // ສ່ວນປຸ່ມ ຕໍ່ໄປ
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: AppConstants.nextButtonText,
                onPressed: _handleNextButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ການສ້າງໜ້າ onboarding
  Widget _buildOnboardingPage(OnboardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ຮູບພາບສຳລັບໜ້າ onboarding
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(page.image, fit: BoxFit.contain),
          ),
        ),

        // ຫົວຂໍ້ແລະຄຳອະທິບາຍ
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
